import SwiftUI

struct CarrierRowView: View {
    let item: CarrierRoute

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 8) {
                Image(item.carrier.smallLogoAssetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 38, height: 38)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.carrier.shortName)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.ypBlack)

                    if let transfer = item.transferDescription {
                        Text(transfer)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(Color(.ypRed))
                    }
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text(item.dateText)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.ypBlack)

                    Rectangle()
                        .frame(width: 10, height: 16)
                        .foregroundStyle(Color(.ypLightGray))
                }
            }

            HStack(alignment: .center, spacing: 6) {
                Text(item.departureTime)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.ypBlack)

                ZStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.ypGray)

                    Text(item.durationText)
                        .font(.system(size: 12, weight: .regular))
                        .padding(.horizontal, 8)
                        .background(
                            Color(.ypLightGray)
                            .clipShape(Capsule())
                        )
                        .foregroundStyle(.ypBlack)
                }

                Text(item.arrivalTime)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.ypBlack)
            }
        }
        .padding(16)
        .background(Color(.ypLightGray))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

#Preview {
    CarrierRowView(
        item: CarrierRoute(
            carrier: Carrier(
                shortName: "РЖД",
                fullName: "ОАО «РЖД»",
                email: "i.lozgkina@yandex.ru",
                phone: "+7 (904) 329-27-71",
                smallLogoAssetName: "rzd_logo",
                largeLogoAssetName: "rzd_logo"
            ),
            transferDescription: "С пересадкой в Костроме",
            dateText: "14 января",
            departureTime: "22:30",
            arrivalTime: "08:15",
            durationText: "20 часов"
        )
    )
    .padding()
}
