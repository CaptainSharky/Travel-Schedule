import SwiftUI

enum CityDirection: Identifiable, Hashable {
    case from
    case to

    var id: Self { self }
}

struct MainView: View {
    @State private var from: String?
    @State private var to: String?
    @State private var activeDirection: CityDirection?

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.ypWhiteDay)
                    .ignoresSafeArea(edges: .top)
                
                DirectionPickerView(
                    fromText: $from,
                    toText: $to,
                    onTapFrom: {
                        activeDirection = .from
                    },
                    onTapTo: {
                        activeDirection = .to
                    },
                    onSwap: {
                        swap(&from, &to)
                    }
                )
                .padding()
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(item: $activeDirection) { direction in
                CitySelectionView(
                    title: "Выбор города",
                    selectedCity: direction == .from ? $from : $to
                )
                .toolbar(.hidden, for: .tabBar)
            }
        }
    }
}

#Preview {
    MainView()
}
