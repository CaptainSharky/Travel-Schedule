import SwiftUI

@MainActor
@Observable final class MainViewModel {
    enum CityDirection: Hashable {
        case from
        case to
    }

    enum Route: Hashable {
        case selectCity(direction: CityDirection)
        case selectStation(direction: CityDirection, city: City)
        case carriersList(
            title: String,
            from: DirectionPickerViewModel.SelectedStation,
            to: DirectionPickerViewModel.SelectedStation
        )
        case error(type: ErrorViewModel.ErrorType)
    }

    var path = NavigationPath()

    var cities: [City] = []
    var isLoadingCities: Bool = false
    var citiesLoadError: String?
    var citiesLoadErrorType: ErrorViewModel.ErrorType?
    var scheduleLoadErrorType: ErrorViewModel.ErrorType?

    var directionPickerViewModel: DirectionPickerViewModel
    var stories: [Story] = Story.mock

    var isSearchButtonEnabled: Bool {
        guard
            let fromText = directionPickerViewModel.fromText,
            let toText = directionPickerViewModel.toText
        else { return false }
        return !fromText.isEmpty && !toText.isEmpty
    }

    private let api: RaspAPIClient

    init(
        directionPickerViewModel: DirectionPickerViewModel = DirectionPickerViewModel(),
        api: RaspAPIClient = RaspAPIClient(apiKey: AppConfig.apiKey),
    ) {
        self.directionPickerViewModel = directionPickerViewModel
        self.api = api
    }

    func tapFrom() {
        if cities.isEmpty, let type = citiesLoadErrorType {
            path.append(Route.error(type: type))
        } else {
            path.append(Route.selectCity(direction: .from))
        }
    }

    func tapTo() {
        if cities.isEmpty, let type = citiesLoadErrorType {
            path.append(Route.error(type: type))
        } else {
            path.append(Route.selectCity(direction: .to))
        }
    }

    func didSelectCity(_ city: City, for direction: CityDirection) {
        path.append(Route.selectStation(direction: direction, city: city))
    }

    func didSelectStation(_ station: Station, direction: CityDirection) {
        let selected = DirectionPickerViewModel.SelectedStation(
            code: station.code,
            cityName: station.cityName,
            stationName: station.title
        )

        switch direction {
        case .from:
            directionPickerViewModel.from = selected
        case .to:
            directionPickerViewModel.to = selected
        }

        path = NavigationPath()
    }

    func search() {
        Task {
            await searchAsync()
        }
    }

    private func searchAsync() async {
        guard
            let from = directionPickerViewModel.from,
            let to = directionPickerViewModel.to
        else { return }

        do {
            _ = try await api.fetchScheduleBetweenStations(from: from.code, to: to.code)
            scheduleLoadErrorType = nil

            let title = "\(from.displayTitle) → \(to.displayTitle)"
            path.append(Route.carriersList(title: title, from: from, to: to))
        } catch {
            let type = ErrorViewModel.mapToErrorType(error)
            scheduleLoadErrorType = type
            path.append(Route.error(type: type))
        }
    }


    func makeCarriersListViewModel(
        title: String,
        from: DirectionPickerViewModel.SelectedStation,
        to: DirectionPickerViewModel.SelectedStation
    ) -> CarriersListViewModel {
        CarriersListViewModel(
            routeTitle: title,
            from: from.code,
            to: to.code,
            apiClient: api
        )
    }

    // MARK: - Loading

    func loadCitiesIfNeeded() async {
        guard cities.isEmpty, !isLoadingCities else { return }

        isLoadingCities = true
        citiesLoadError = nil
        citiesLoadErrorType = nil
        defer { isLoadingCities = false }

        do {
            async let nearest = api.fetchNearestStations(
                lat: 55.755864,
                lng: 37.617698,
                distance: 50
            )

            let response = try await nearest
            let preparedCities = Self.makeCities(from: response)

            self.cities = preparedCities.sorted { $0.name < $1.name }
        } catch {
            self.citiesLoadError = String(describing: error)
            self.citiesLoadErrorType = ErrorViewModel.mapToErrorType(error)
            self.cities = []
        }
    }

    func showError(_ type: ErrorViewModel.ErrorType) {
        path.append(Route.error(type: type))
    }

    // MARK: - Mapping OpenAPI -> Domain

    nonisolated private static func makeCities(from nearest: NearestStations) -> [City] {
        let apiStations = nearest.stations ?? []

        var grouped: [String: [Station]] = [:]
        grouped.reserveCapacity(16)

        for s in apiStations {
            let rawTitle = (s.title ?? s.popular_title ?? s.short_title ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let code = (s.code ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

            guard !rawTitle.isEmpty, !code.isEmpty else { continue }

            let (city, stationName) = StationTitleParser.splitCityAndStation(from: rawTitle)
            let station = Station(code: code, title: stationName, cityName: city)

            grouped[city, default: []].append(station)
        }

        return grouped
            .map { (cityName, stations) in
                City(
                    name: cityName,
                    stations: stations.sorted { $0.title < $1.title }
                )
            }
    }
}

enum AppConfig {
    static let apiKey = "bb6ebbc8-d4ec-44d1-a927-87d67ced6345"
}

