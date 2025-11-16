import SwiftUI

struct TabBar: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image(.tabMain)
                }
            Text("Настройки")
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
