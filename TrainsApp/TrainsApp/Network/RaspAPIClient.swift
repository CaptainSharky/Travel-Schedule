import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

actor RaspAPIClient {
    enum APIError: Error {
        case missingCarrierInResponse
    }

    private let client: Client
    private let apiKey: String

    private let nearestStationsService: NearestStationsService
    private let scheduleBetweenService: ScheduleBetweenService
    private let carrierInfoService: CarrierInfoService

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
        self.carrierInfoService = CarrierInfoService(client: client, apikey: apiKey)
    }

    func fetchNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStations {
        try await nearestStationsService.getNearestStations(lat: lat, lng: lng, distance: distance)
    }

    func fetchScheduleBetweenStations(from: String, to: String) async throws -> ScheduleBetweenStations {
        try await scheduleBetweenService.getScheduleBetweenStations(from: from, to: to)
    }

    func fetchCarrierDetails(code: String) async throws -> CarrierDetails {
            let response = try await carrierInfoService.getCarrierInfo(code: code)
            guard let carrier = response.carrier else {
                throw APIError.missingCarrierInResponse
            }

            return CarrierDetails(
                code: code,
                title: carrier.title ?? "Перевозчик",
                email: carrier.email ?? "",
                phone: carrier.phone ?? "",
                url: carrier.url ?? "",
                logoURLString: carrier.logo ?? "",
                address: carrier.address ?? "",
                contacts: carrier.contacts ?? ""
            )
        }
}
