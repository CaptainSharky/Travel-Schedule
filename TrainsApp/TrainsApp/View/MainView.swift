import SwiftUI

struct MainView: View {
    @State private var viewModel = MainViewModel()

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            ZStack {
                Color(.ypWhiteDay)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    DirectionPickerView(
                        viewModel: viewModel.directionPickerViewModel,
                        onTapFrom: {
                            viewModel.tapFrom()
                        },
                        onTapTo: {
                            viewModel.tapTo()
                        }
                    )
                    .padding(.horizontal, 16)

                    if viewModel.isSearchButtonEnabled {
                        Button {
                            viewModel.search()
                        } label: {
                            Text("Найти")
                                .font(.system(size: 17, weight: .bold))
                                .frame(width: 150, height: 60)
                                .background(Color(.ypBlue))
                                .foregroundStyle(Color(.ypWhite))
                                .cornerRadius(16)
                        }
                    }
                }
            }
            .navigationDestination(for: MainViewModel.Route.self) { route in
                switch route {
                case .selectCity(let direction):
                    SelectionView(
                        viewModel: SelectionViewModel(
                            title: "Выбор города",
                            items: viewModel.cities.map { $0.name },
                            emptyStateText: "Город не найден"
                        ),
                        onItemSelected: { cityName in
                            viewModel.didSelectCity(
                                named: cityName,
                                for: direction
                            )
                        }
                    )
                    .toolbar(.hidden, for: .tabBar)

                case .selectStation(let direction, let city):
                    SelectionView(
                        viewModel: SelectionViewModel(
                            title: "Выбор станции",
                            items: city.stations,
                            emptyStateText: "Станция не найдена"
                        ),
                        onItemSelected: { stationName in
                            viewModel.didSelectStation(
                                stationName,
                                direction: direction,
                                in: city
                            )
                        }
                    )
                    .toolbar(.hidden, for: .tabBar)

                case .carriersList(let title):
                    CarriersListView(
                        viewModel: CarriersListViewModel(
                            routeTitle: title
                        )
                    )
                    .toolbar(.hidden, for: .tabBar)
                }
            }
        }
    }
}

#Preview {
    MainView()
}
