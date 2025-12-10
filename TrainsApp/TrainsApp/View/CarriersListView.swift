import SwiftUI

struct CarriersListView: View {
    @Bindable var viewModel: CarriersListViewModel

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(.ypWhiteDay)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.routeTitle)
                        .font(.system(size: 24, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .padding(16)

                    ForEach(viewModel.items) { item in
                        CarrierRowView(item: item)
                            .padding(.horizontal, 16)
                    }
                }
            }

            VStack {
                Spacer()

                Button {

                } label: {
                    Text("Уточнить время")
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color(.ypBlue))
                        .foregroundStyle(Color(.ypWhite))
                        .cornerRadius(16)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .overlay {
            if viewModel.shouldShowEmptyState {
                Text("Вариантов нет")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color(.ypBlackDay))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .allowsHitTesting(false)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
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
        CarriersListView(
            viewModel: CarriersListViewModel(
                routeTitle: "Москва (Ярославский вокзал) → Санкт Петербург (Балтийский вокзал)",
                items: []
            )
        )
    }
}
