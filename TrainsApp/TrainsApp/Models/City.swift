struct Station: Identifiable, Hashable, Sendable {
    let code: String
    let title: String
    let cityName: String

    var id: String { code }

    var displayTitle: String { "\(cityName) (\(title))" }
}

struct City: Identifiable, Hashable, Sendable {
    let name: String
    let stations: [Station]

    var id: String { name }
}
