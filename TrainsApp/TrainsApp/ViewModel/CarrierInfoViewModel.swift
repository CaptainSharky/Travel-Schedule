import Observation
import Foundation

@MainActor
@Observable final class CarrierInfoViewModel {
    let code: String

    var details: CarrierDetails?
    var isLoading: Bool = false
    var lastError: Error? = nil
    var reloadTrigger: Int = 0

    private let apiClient: RaspAPIClient
    private var didInitialLoad: Bool = false

    init(code: String, apiClient: RaspAPIClient) {
        self.code = code
        self.apiClient = apiClient
    }

    func loadIfNeeded() async {
        guard !didInitialLoad else { return }
        didInitialLoad = true
        await reload()
    }

    func reload() async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }

        do {
            details = try await apiClient.fetchCarrierDetails(code: code)
        } catch {
            details = nil
            lastError = error
        }
    }
}
