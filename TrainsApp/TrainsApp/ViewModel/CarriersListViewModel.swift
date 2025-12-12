import Observation

@Observable final class CarriersListViewModel {
    let routeTitle: String
    var items: [CarrierRoute]

    private let allItems: [CarrierRoute]

    var activeDepartureRanges: Set<DepartureTimeRange> = []
    var activeTransfersFilter: TransfersFilter?

    var shouldShowEmptyState: Bool {
        items.isEmpty
    }

    var hasActiveFilters: Bool {
        !activeDepartureRanges.isEmpty || activeTransfersFilter != nil
    }

    private let itemsMock = [
        CarrierRoute(
            carrierName: "РЖД",
            logoImageName: "rzd_logo",
            transferDescription: "С пересадкой в Костроме",
            dateText: "14 января",
            departureTime: "22:30",
            arrivalTime: "08:15",
            durationText: "20 часов"
        ),
        CarrierRoute(
            carrierName: "ФГК",
            logoImageName: "fgk_logo",
            transferDescription: nil,
            dateText: "15 января",
            departureTime: "01:15",
            arrivalTime: "09:00",
            durationText: "9 часов"
        ),
        CarrierRoute(
            carrierName: "Урал логистика",
            logoImageName: "ural_logo",
            transferDescription: nil,
            dateText: "16 января",
            departureTime: "12:30",
            arrivalTime: "21:00",
            durationText: "9 часов"
        ),
        CarrierRoute(
            carrierName: "РЖД",
            logoImageName: "rzd_logo",
            transferDescription: "С пересадкой в Костроме",
            dateText: "17 января",
            departureTime: "22:30",
            arrivalTime: "08:15",
            durationText: "20 часов"
        ),
        CarrierRoute(
            carrierName: "РЖД",
            logoImageName: "rzd_logo",
            transferDescription: "С пересадкой в Гунганово",
            dateText: "17 января",
            departureTime: "20:30",
            arrivalTime: "05:15",
            durationText: "19 часов"
        )
    ]

    init(routeTitle: String, items: [CarrierRoute]? = nil) {
        self.routeTitle = routeTitle
        allItems = items ?? itemsMock
        self.items = allItems
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
                let hasTransfer = route.hasTransfer
                if hasTransfer {
                    return false
                }
            }

            return true
        }
    }
}
