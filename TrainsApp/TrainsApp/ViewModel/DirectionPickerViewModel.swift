import Observation

@MainActor
@Observable final class DirectionPickerViewModel {

    struct SelectedStation: Hashable, Sendable {
        let code: String
        let cityName: String
        let stationName: String

        var displayTitle: String { "\(cityName) (\(stationName))" }
    }

    var from: SelectedStation?
    var to: SelectedStation?

    var fromText: String? { from?.displayTitle }
    var toText: String? { to?.displayTitle }

    func swap() {
        Swift.swap(&from, &to)
    }
}
