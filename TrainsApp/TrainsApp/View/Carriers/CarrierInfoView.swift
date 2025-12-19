import SwiftUI

struct CarrierInfoView: View {
    let carrier: Carrier
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(.ypWhiteDay)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Image(carrier.largeLogoAssetName)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)

                Text(carrier.fullName)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.ypBlackDay)
                    .padding(.top, 24)
                    .padding(.horizontal, 16)

                VStack(alignment: .leading, spacing: 0) {
                    Text("E-mail")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.ypBlackDay)

                    Link(carrier.email, destination: URL(string: "mailto:\(carrier.email)")!)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.ypBlue)
                }
                .padding(.top, 28)
                .padding(.horizontal, 16)

                VStack(alignment: .leading) {
                    Text("Телефон")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.ypBlackDay)

                    let phoneDigits = carrier.phone.filter { "0123456789+".contains($0) }
                    Link(carrier.phone, destination: URL(string: "tel:\(phoneDigits)")!)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.ypBlue)
                }
                .padding(.top, 24)
                .padding(.horizontal, 16)

                Spacer()
            }
            .padding(.top, 16)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Информация о перевозчике")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.ypBlackDay)
            }

            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 19, weight: .semibold))
                        .foregroundStyle(.ypBlackDay)
                }
            }
        }
        .tint(.ypBlackDay)
    }
}

#Preview {
    NavigationStack {
        CarrierInfoView(
            carrier: Carrier(
                shortName: "РЖД",
                fullName: "ОАО «РЖД»",
                email: "i.lozgkina@yandex.ru",
                phone: "+7 (904) 329-27-71",
                smallLogoAssetName: "rzd_logo",
                largeLogoAssetName: "rzd_logo_huge"
            )
        )
    }
}
