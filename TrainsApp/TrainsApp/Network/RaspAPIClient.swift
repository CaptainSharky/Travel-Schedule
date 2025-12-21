import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

actor RaspAPIClient {

    private let client: Client
    private let apiKey: String

    private let nearestStationsService: NearestStationsService

    init(apiKey: String) {
        self.apiKey = apiKey

        let serverURL = URL(string: "https://api.rasp.yandex.net")!
        self.client = Client(serverURL: serverURL, transport: URLSessionTransport())

        self.nearestStationsService = NearestStationsService(client: client, apikey: apiKey)
    }

    func fetchNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStations {
        try await nearestStationsService.getNearestStations(lat: lat, lng: lng, distance: distance)
    }
}
