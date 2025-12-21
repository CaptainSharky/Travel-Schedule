import Foundation

struct Carrier: Identifiable, Hashable, Sendable {
    let id: UUID
    let code: String?
    let shortName: String
    let fullName: String
    let email: String
    let phone: String
    let smallLogoAssetName: String
    let largeLogoAssetName: String

    init(
        id: UUID = UUID(),
        code: String? = nil,
        shortName: String,
        fullName: String,
        email: String,
        phone: String,
        smallLogoAssetName: String,
        largeLogoAssetName: String
    ) {
        self.id = id
        self.code = code
        self.shortName = shortName
        self.fullName = fullName
        self.email = email
        self.phone = phone
        self.smallLogoAssetName = smallLogoAssetName
        self.largeLogoAssetName = largeLogoAssetName
    }
}

struct CarrierDetails: Hashable, Sendable {
    let code: String
    let title: String
    let email: String
    let phone: String
    let url: String
    let logoURLString: String
    let address: String
    let contacts: String

    var logoURL: URL? {
        URL(string: logoURLString)
    }
}
