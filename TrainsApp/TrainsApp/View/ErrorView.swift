import SwiftUI

struct ErrorView: View {
    @State private var viewModel: ErrorViewModel

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
    }
}

#Preview {
    ErrorView(viewModel: ErrorViewModel(errorType: .noInternet))
}
