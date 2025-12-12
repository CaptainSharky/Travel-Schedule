enum DepartureTimeRange: CaseIterable, Identifiable, Hashable {
    case morning
    case day
    case evening
    case night

    var id: Self { self }

    var title: String {
        switch self {
        case .morning:
            return "Утро 06:00 - 12:00"
        case .day:
            return "День 12:00 - 18:00"
        case .evening:
            return "Вечер 18:00 - 00:00"
        case .night:
            return "Ночь 00:00 - 06:00"
        }
    }

    var startMinutes: Int {
        switch self {
        case .morning:
            return 6 * 60
        case .day:
            return 12 * 60
        case .evening:
            return 18 * 60
        case .night:
            return 0
        }
    }

    var endMinutes: Int {
        switch self {
        case .morning:
            return 12 * 60
        case .day:
            return 18 * 60
        case .evening:
            return 24 * 60
        case .night:
            return 6 * 60
        }
    }

    func contains(minutes: Int) -> Bool {
        minutes >= startMinutes && minutes < endMinutes
    }
}
