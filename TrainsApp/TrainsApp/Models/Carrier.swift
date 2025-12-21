import Foundation

struct Carrier: Identifiable, Hashable, Sendable {
    let id: UUID
    let shortName: String
    let fullName: String
    let email: String
    let phone: String
    let smallLogoAssetName: String
    let largeLogoAssetName: String

    init(
        id: UUID = UUID(),
        shortName: String,
        fullName: String,
        email: String,
        phone: String,
        smallLogoAssetName: String,
        largeLogoAssetName: String
    ) {
        self.id = id
        self.shortName = shortName
        self.fullName = fullName
        self.email = email
        self.phone = phone
        self.smallLogoAssetName = smallLogoAssetName
        self.largeLogoAssetName = largeLogoAssetName
    }
}
