import SwiftUI

struct ErrorView: View {
    @State private var viewModel: ErrorViewModel

    @Environment(\.dismiss) private var dismiss

    init(viewModel: ErrorViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color(.ypWhiteDay)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                viewModel.image
                    .resizable()
                    .frame(width: 223, height: 223)

                Text(viewModel.errorText)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.ypBlackDay)
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
    ErrorView(viewModel: ErrorViewModel(errorType: .noInternet))
}
