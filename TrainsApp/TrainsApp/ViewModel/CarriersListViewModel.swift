import Observation
import Foundation

@MainActor
@Observable final class CarriersListViewModel {
    let routeTitle: String
    var items: [CarrierRoute] = []
    var isLoading: Bool = false
    var lastError: Error? = nil
    var reloadTrigger: Int = 0

    var activeDepartureRanges: Set<DepartureTimeRange> = []
    var activeTransfersFilter: TransfersFilter?

    var shouldShowEmptyState: Bool { !isLoading && items.isEmpty }

    var hasActiveFilters: Bool {
        !activeDepartureRanges.isEmpty || activeTransfersFilter != nil
    }

    private var allItems: [CarrierRoute] = []
    private let apiClient: RaspAPIClient?
    private let fromStationCode: String?
    private let toStationCode: String?
    private var didInitialLoad: Bool = false

    init(routeTitle: String, from: String, to: String, apiClient: RaspAPIClient) {
        self.routeTitle = routeTitle
        self.fromStationCode = from
        self.toStationCode = to
        self.apiClient = apiClient
    }

    init(routeTitle: String, items: [CarrierRoute]) {
        self.routeTitle = routeTitle
        self.items = items
        self.allItems = items
        self.apiClient = nil
        self.fromStationCode = nil
        self.toStationCode = nil
        self.didInitialLoad = true
    }

    func retry() {
        reloadTrigger += 1
    }

    func loadIfNeeded() async throws {
        guard !didInitialLoad else { return }
        didInitialLoad = true
        try? await reload()
    }

    func reload() async throws {
        guard let apiClient,
              let fromStationCode,
              let toStationCode
        else { return }

        isLoading = true
        lastError = nil
        defer { isLoading = false }

        do {
            let schedule = try await apiClient.fetchScheduleBetweenStations(from: fromStationCode, to: toStationCode)
            let mapped = Self.mapToCarrierRoutes(schedule)

            allItems = mapped
            applyFilters(timeRanges: activeDepartureRanges, transfers: activeTransfersFilter)
        } catch {
            if let decoding = error as? DecodingError {
                print("DECODING ERROR:", decoding)
            } else {
                print("ERROR:", error)
            }
            lastError = error
            items = []
            allItems = []
            throw error
        }
    }

    func applyFilters(timeRanges: Set<DepartureTimeRange>, transfers: TransfersFilter?) {
        activeDepartureRanges = timeRanges
        activeTransfersFilter = transfers

        guard !timeRanges.isEmpty || transfers != nil else {
            items = allItems
            return
        }

        items = allItems.filter { route in
            if !timeRanges.isEmpty {
                guard let minutes = route.departureMinutes else { return false }
                let matchesTime = timeRanges.contains { $0.contains(minutes: minutes) }
                if !matchesTime { return false }
            }

            if transfers == .no {
                if route.hasTransfer { return false }
            }

            return true
        }
    }
}

private extension CarriersListViewModel {

    static func mapToCarrierRoutes(_ schedule: ScheduleBetweenStations) -> [CarrierRoute] {
        let segments = schedule.segments ?? []
        return segments.compactMap { segment in
            guard let thread = segment.thread,
                  let apiCarrier = thread.carrier
            else { return nil }

            let carrier = Carrier(
                shortName: apiCarrier.title ?? "Перевозчик",
                fullName: apiCarrier.title ?? "Перевозчик",
                email: apiCarrier.email ?? "",
                phone: apiCarrier.phone ?? "",
                smallLogoAssetName: logoAssetName(for: apiCarrier),
                largeLogoAssetName: logoAssetName(for: apiCarrier)
            )

            guard let dep = segment.departure,
                  let arr = segment.arrival
            else { return nil }

            let dateText = formatDateText(dep)
            let departureTime = formatTime(dep)
            let arrivalTime = formatTime(arr)
            let durationText = formatDuration(seconds: segment.duration)

            let transferDescription: String? = nil

            return CarrierRoute(
                carrier: carrier,
                transferDescription: transferDescription,
                dateText: dateText,
                departureTime: departureTime,
                arrivalTime: arrivalTime,
                durationText: durationText
            )
        }
    }

    static func formatDateText(_ date: Date) -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        df.calendar = Calendar(identifier: .gregorian)
        df.dateFormat = "d MMMM"
        return df.string(from: date)
    }

    static func formatTime(_ date: Date) -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        df.calendar = Calendar(identifier: .gregorian)
        df.dateFormat = "HH:mm"
        return df.string(from: date)
    }

    static func formatDuration(seconds: Int?) -> String {
        let total = max(0, seconds ?? 0)
        let hours = total / 3600
        let minutes = (total % 3600) / 60

        if minutes == 0 {
            return "\(hours) \(russianHoursWord(hours))"
        }
        if hours == 0 {
            return "\(minutes) \(russianMinutesWord(minutes))"
        }
        return "\(hours) \(russianHoursWord(hours)) \(minutes) \(russianMinutesWord(minutes))"
    }

    static func russianHoursWord(_ n: Int) -> String {
        let nAbs = abs(n)
        let mod10 = nAbs % 10
        let mod100 = nAbs % 100
        if mod100 >= 11 && mod100 <= 14 { return "часов" }
        switch mod10 {
        case 1: return "час"
        case 2,3,4: return "часа"
        default: return "часов"
        }
    }

    static func russianMinutesWord(_ n: Int) -> String {
        let nAbs = abs(n)
        let mod10 = nAbs % 10
        let mod100 = nAbs % 100
        if mod100 >= 11 && mod100 <= 14 { return "минут" }
        switch mod10 {
        case 1: return "минута"
        case 2,3,4: return "минуты"
        default: return "минут"
        }
    }

    static func logoAssetName(for apiCarrier: Components.Schemas.Carrier) -> String {
        if let code = apiCarrier.code {
            switch code {
            case 26: return "rzd_logo"
            default: break
            }
        }
        return "rzd_logo"
    }
}
