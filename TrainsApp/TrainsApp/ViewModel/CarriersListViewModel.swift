import Observation

@Observable final class CarriersListViewModel {
    let routeTitle: String
    let items: [CarrierRoute]

    var shouldShowEmptyState: Bool {
        items.isEmpty
    }

    let itemsMock = [
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

    init(routeTitle: String, items: [CarrierRoute]) {
        self.routeTitle = routeTitle
        self.items = itemsMock
    }
}
