import Foundation

struct CarrierRoute: Identifiable, Hashable {
    let id = UUID()
    let carrier: Carrier
    let transferDescription: String?
    let dateText: String
    let departureTime: String
    let arrivalTime: String
    let durationText: String
}

extension CarrierRoute {
    var departureMinutes: Int? {
        let parts = departureTime.split(separator: ":")
        guard parts.count == 2,
              let hours = Int(parts[0]),
              let minutes = Int(parts[1]) else { return nil }
        return hours * 60 + minutes
    }

    var hasTransfer: Bool {
        transferDescription != nil
    }
}
