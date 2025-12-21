import Foundation

struct Carrier: Identifiable, Hashable {
    let id = UUID()
    let shortName: String
    let fullName: String
    let email: String
    let phone: String
    let smallLogoAssetName: String
    let largeLogoAssetName: String
}
