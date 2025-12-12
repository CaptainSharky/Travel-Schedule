import Observation

@Observable final class DirectionPickerViewModel {
    var fromText: String?
    var toText: String?

    init(fromText: String? = nil, toText: String? = nil) {
        self.fromText = fromText
        self.toText = toText
    }

    func swap() {
        Swift.swap(&fromText, &toText)
    }
}
