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
}
