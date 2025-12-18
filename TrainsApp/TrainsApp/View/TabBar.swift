import SwiftUI

struct TabBar: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image(.tabMain)
                }
            SettingsView()
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
