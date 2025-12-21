import SwiftUI

@Observable final class ErrorViewModel {
    enum ErrorType {
        case serverError
        case noInternet
    }

    let errorText: String
    let image: Image

    init(errorType: ErrorType) {
        switch errorType {
        case .serverError:
            errorText = "Ошибка сервера"
            image = Image(.errorServer)
        case .noInternet:
            errorText = "Нет интернета"
            image = Image(.errorInternet)
        }
    }

    static func mapToErrorType(_ error: Error) -> ErrorViewModel.ErrorType {
        if let urlError = error as? URLError {
            return isNoInternet(urlError) ? .noInternet : .serverError
        }

        return .serverError
    }

    nonisolated private static func isNoInternet(_ error: URLError) -> Bool {
        switch error.code {
        case .notConnectedToInternet,
             .networkConnectionLost,
             .cannotConnectToHost,
             .cannotFindHost,
             .dnsLookupFailed,
             .internationalRoamingOff:
            return true
        default:
            return false
        }
    }
}
