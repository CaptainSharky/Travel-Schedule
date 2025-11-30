import SwiftUI

@Observable final class MainViewModel {
    enum CityDirection: Hashable {
        case from
        case to
    }

    enum Route: Hashable {
        case selectCity(direction: CityDirection)
        case selectStation(direction: CityDirection, city: City)
    }

    var path = NavigationPath()
    var cities: [City]
    var directionPickerViewModel: DirectionPickerViewModel

    var isSearchButtonEnabled: Bool {
        guard
            let fromText = directionPickerViewModel.fromText,
            let toText = directionPickerViewModel.toText
        else { return false }
        return !fromText.isEmpty && !toText.isEmpty
    }

    init(directionPickerViewModel: DirectionPickerViewModel = DirectionPickerViewModel()) {
        cities = citiesMockData
        self.directionPickerViewModel = directionPickerViewModel
    }

    private let citiesMockData: [City] = [
        City(name: "Москва", stations: [
            "Киевский вокзал",
            "Курский вокзал",
            "Ярославский вокзал",
            "Белорусский вокзал",
            "Савеловский вокзал",
            "Ленинградский вокзал"
        ]),
        City(name: "Санкт Петербург", stations: [
            "Балтийский вокзал",
            "Московский вокзал",
            "Ладожский вокзал"
        ]),
        City(name: "Сочи", stations: ["Сочи", "Адлер"]),
        City(name: "Горный воздух", stations: ["Горный воздух"]),
        City(name: "Краснодар", stations: ["Краснодар-1", "Краснодар-2"]),
        City(name: "Казань", stations: ["Казань", "Казань-2"]),
        City(name: "Омск", stations: ["Омск-Пассажирский"])
    ]

    func tapFrom() {
        path.append(Route.selectCity(direction: .from))
    }

    func tapTo() {
        path.append(Route.selectCity(direction: .to))
    }

    func didSelectCity(named cityName: String, for direction: CityDirection) {
        guard let city = cities.first(where: { $0.name == cityName }) else { return }
        path.append(Route.selectStation(direction: direction, city: city))
    }

    func didSelectStation(_ stationName: String, direction: CityDirection, in city: City) {
        let fullTitle = "\(city.name) (\(stationName))"

        switch direction {
        case .from:
            directionPickerViewModel.fromText = fullTitle
        case .to:
            directionPickerViewModel.toText = fullTitle
        }

        path = NavigationPath()
    }
}
