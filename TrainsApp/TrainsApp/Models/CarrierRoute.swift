import Foundation

struct CarrierRoute: Identifiable, Hashable {
    let id = UUID()
    let carrierName: String
    let logoImageName: String
    let transferDescription: String?
    let dateText: String
    let departureTime: String
    let arrivalTime: String
    let durationText: String
}
