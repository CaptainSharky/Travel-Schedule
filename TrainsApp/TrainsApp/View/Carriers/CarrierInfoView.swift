import SwiftUI

struct CarrierInfoView: View {
    let carrier: Carrier
    let apiClient: RaspAPIClient?

    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: CarrierInfoViewModel?

    init(carrier: Carrier, apiClient: RaspAPIClient? = nil) {
        self.carrier = carrier
        self.apiClient = apiClient

        if let apiClient, let code = carrier.code {
            _viewModel = State(initialValue: CarrierInfoViewModel(code: code, apiClient: apiClient))
        } else {
            _viewModel = State(initialValue: nil)
        }
    }

    var body: some View {
        let name = viewModel?.details?.title ?? carrier.fullName
        let email = viewModel?.details?.email ?? carrier.email
        let phone = viewModel?.details?.phone ?? carrier.phone
        let logoURL = viewModel?.details?.logoURL

        ZStack {
            Color(.ypWhiteDay).ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {

                HStack {
                    Spacer()
                    headerImage(logoURL: logoURL)
                    Spacer()
                }
                .background(Color(.ypWhite))
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .frame(maxWidth: .infinity, maxHeight: 150)
                .padding(.horizontal, 16)

                Text(name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.ypBlackDay)
                    .padding(.top, 24)
                    .padding(.horizontal, 16)

                infoBlock(title: "E-mail") {
                    if let url = URL(string: "mailto:\(email)"), !email.isEmpty {
                        Link(email, destination: url)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.ypBlue)
                    } else {
                        Text("—")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.ypBlackDay)
                    }
                }
                .padding(.top, 28)
                .padding(.horizontal, 16)

                infoBlock(title: "Телефон") {
                    let phoneDigits = phone.filter { "0123456789+".contains($0) }
                    if let url = URL(string: "tel:\(phoneDigits)"), !phone.isEmpty {
                        Link(phone, destination: url)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.ypBlue)
                    } else {
                        Text("—")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.ypBlackDay)
                    }
                }
                .padding(.top, 24)
                .padding(.horizontal, 16)

                Spacer()
            }
            .padding(.top, 16)

            if viewModel?.isLoading == true {
                ZStack {
                    Color.black.opacity(0.15).ignoresSafeArea()
                    ProgressView().scaleEffect(1.2)
                }
            }
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
        .task(id: viewModel?.reloadTrigger ?? 0) {
            await viewModel?.loadIfNeeded()
        }
    }

    @ViewBuilder
    private func headerImage(logoURL: URL?) -> some View {
        if let logoURL {
            AsyncImage(url: logoURL) { phase in
                switch phase {
                case .empty:
                    Image(carrier.largeLogoAssetName)
                        .resizable()
                        .scaledToFit()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    Image(carrier.largeLogoAssetName)
                        .resizable()
                        .scaledToFit()
                @unknown default:
                    Image(carrier.largeLogoAssetName)
                        .resizable()
                        .scaledToFit()
                }
            }
        } else {
            Image(carrier.largeLogoAssetName)
                .resizable()
                .scaledToFit()
        }
    }

    private func infoBlock<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.ypBlackDay)
            content()
        }
    }
}

#Preview {
    CarrierInfoView(carrier: Carrier(
        shortName: "РЖД",
        fullName: "ОАО «РЖД»",
        email: "i.lozgkina@yandex.ru",
        phone: "+7 (904) 329-27-71",
        smallLogoAssetName: "rzd_logo",
        largeLogoAssetName: "rzd_logo_huge"
    ), apiClient: nil)
}
