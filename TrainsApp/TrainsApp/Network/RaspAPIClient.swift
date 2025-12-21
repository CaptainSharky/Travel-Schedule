import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

actor RaspAPIClient {

    private let client: Client
    private let apiKey: String

    private let nearestStationsService: NearestStationsService
    private let scheduleBetweenService: ScheduleBetweenService

    init(apiKey: String) {
        self.apiKey = apiKey

        let serverURL = URL(string: "https://api.rasp.yandex.net")!
        self.client = Client(
            serverURL: serverURL,
            configuration: Configuration(dateTranscoder: RaspDateTranscoder()),
            transport: URLSessionTransport()
        )

        self.nearestStationsService = NearestStationsService(client: client, apikey: apiKey)
        self.scheduleBetweenService = ScheduleBetweenService(client: client, apikey: apiKey)
    }

    func fetchNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStations {
        try await nearestStationsService.getNearestStations(lat: lat, lng: lng, distance: distance)
    }

    func fetchScheduleBetweenStations(from: String, to: String) async throws -> ScheduleBetweenStations {
        try await scheduleBetweenService.getScheduleBetweenStations(from: from, to: to)
    }
}
