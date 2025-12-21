import Foundation

struct CarrierRoute: Identifiable, Hashable, Sendable {
    let id: UUID
    let carrier: Carrier
    let transferDescription: String?
    let dateText: String
    let departureTime: String
    let arrivalTime: String
    let durationText: String

    init(
        id: UUID = UUID(),
        carrier: Carrier,
        transferDescription: String?,
        dateText: String,
        departureTime: String,
        arrivalTime: String,
        durationText: String
    ) {
        self.id = id
        self.carrier = carrier
        self.transferDescription = transferDescription
        self.dateText = dateText
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
        self.durationText = durationText
    }
}

extension CarrierRoute {
    var departureMinutes: Int? {
        let parts = departureTime.split(separator: ":")
        guard parts.count == 2,
              let hours = Int(parts[0]),
              let minutes = Int(parts[1]) else { return nil }
        return hours * 60 + minutes
    }

    var hasTransfer: Bool { transferDescription != nil }
}
