import Observation

@Observable final class CarriersListViewModel {
    let routeTitle: String
    var items: [CarrierRoute] = []

    private var allItems: [CarrierRoute] = []

    var activeDepartureRanges: Set<DepartureTimeRange> = []
    var activeTransfersFilter: TransfersFilter?

    var shouldShowEmptyState: Bool {
        items.isEmpty
    }

    var hasActiveFilters: Bool {
        !activeDepartureRanges.isEmpty || activeTransfersFilter != nil
    }

    private let rzd = Carrier(
        shortName: "РЖД",
        fullName: "ОАО «РЖД»",
        email: "i.lozgkina@yandex.ru",
        phone: "+7 (904) 329-27-71",
        smallLogoAssetName: "rzd_logo",
        largeLogoAssetName: "rzd_logo_huge"
    )

    private let fgk = Carrier(
        shortName: "ФГК",
        fullName: "АО «ФГК»",
        email: "info@fgk.ru",
        phone: "+7 (800) 000-00-00",
        smallLogoAssetName: "fgk_logo",
        largeLogoAssetName: "rzd_logo_huge"
    )

    private let ural = Carrier(
        shortName: "Урал логистика",
        fullName: "ООО «Урал логистика»",
        email: "support@ural-log.ru",
        phone: "+7 (800) 111-22-33",
        smallLogoAssetName: "ural_logo",
        largeLogoAssetName: "rzd_logo_huge"
    )

    private var itemsMock: [CarrierRoute] {
        [
            CarrierRoute(
                carrier: rzd,
                transferDescription: "С пересадкой в Костроме",
                dateText: "14 января",
                departureTime: "22:30",
                arrivalTime: "08:15",
                durationText: "20 часов"
            ),
            CarrierRoute(
                carrier: fgk,
                transferDescription: nil,
                dateText: "15 января",
                departureTime: "01:15",
                arrivalTime: "09:00",
                durationText: "9 часов"
            ),
            CarrierRoute(
                carrier: ural,
                transferDescription: nil,
                dateText: "16 января",
                departureTime: "12:30",
                arrivalTime: "21:00",
                durationText: "9 часов"
            ),
            CarrierRoute(
                carrier: rzd,
                transferDescription: "С пересадкой в Костроме",
                dateText: "17 января",
                departureTime: "22:30",
                arrivalTime: "08:15",
                durationText: "20 часов"
            ),
            CarrierRoute(
                carrier: rzd,
                transferDescription: "С пересадкой в Гунганово",
                dateText: "17 января",
                departureTime: "23:30",
                arrivalTime: "09:15",
                durationText: "20 часов"
            )
        ]
    }

    init(routeTitle: String, items: [CarrierRoute]? = nil) {
        self.routeTitle = routeTitle
        let source = items ?? itemsMock
        self.allItems = source
        self.items = source
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
