import SwiftUI

struct TabBar: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image(.tabMain)
                }
            ErrorView(viewModel: ErrorViewModel(errorType: .serverError))
                .tabItem {
                    Image(.tabSettings)
                }
        }
        .tint(.ypBlackDay)
    }
}

#Preview {
    TabBar()
}
