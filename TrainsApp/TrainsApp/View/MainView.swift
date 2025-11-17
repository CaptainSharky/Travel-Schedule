import SwiftUI

private enum CityDirection: Hashable {
    case from
    case to
}

private enum Route: Hashable {
    case selectCity(direction: CityDirection)
    case selectStation(direction: CityDirection, city: City)
}

struct MainView: View {
    @State private var from: String?
    @State private var to: String?
    @State private var path = NavigationPath()

    private let cities = citiesData

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color(.ypWhiteDay)
                    .ignoresSafeArea(edges: .top)
                
                DirectionPickerView(
                    fromText: $from,
                    toText: $to,
                    onTapFrom: {
                        path.append(Route.selectCity(direction: .from))
                    },
                    onTapTo: {
                        path.append(Route.selectCity(direction: .to))
                    },
                    onSwap: {
                        swap(&from, &to)
                    }
                )
                .padding()
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .selectCity(let direction):
                    SelectionView(
                        title: "Выбор города",
                        items: cities.map { $0.name }
                    ) { cityName in
                        guard let city = cities.first(where: { $0.name == cityName }) else { return }
                        path.append(Route.selectStation(direction: direction, city: city))
                    }
                    .toolbar(.hidden, for: .tabBar)

                case .selectStation(let direction, let city):
                    SelectionView(
                        title: "Выбор станции",
                        items: city.stations
                    ) { stationName in
                        let fullTitle = "\(city.name) (\(stationName))"

                        switch direction {
                        case .from:
                            from = fullTitle
                        case .to:
                            to = fullTitle
                        }
                        path = NavigationPath()
                    }
                    .toolbar(.hidden, for: .tabBar)
                }
            }
        }
    }
}

private let citiesData: [City] = [
    City(name: "Москва", stations: [
        "Курский вокзал",
        "Казанский вокзал",
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

#Preview {
    MainView()
}
