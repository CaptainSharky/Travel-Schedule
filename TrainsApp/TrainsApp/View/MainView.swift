import SwiftUI

struct MainView: View {
    @State private var viewModel = MainViewModel()
    @State private var isStoriesPresented = false
    @State private var selectedStoryID: UUID?
    @State private var selectedStory: Story? = nil

    private var storiesBinding: Binding<[Story]> {
        Binding(
            get: { viewModel.stories },
            set: { viewModel.stories = $0 }
        )
    }

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            ZStack(alignment: .top) {
                Color(.ypWhiteDay)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    StoriesRowView(stories: viewModel.stories) { story in
                        guard story.isViewed == false else { return }
                        selectedStory = story
                    }
                    .fullScreenCover(item: $selectedStory) { story in
                        StoriesViewerView(stories: storiesBinding, startStoryID: story.id)
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 28)

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

                    if let err = viewModel.citiesLoadError {
                        Text("Ошибка загрузки: \(err)")
                            .font(.system(size: 13))
                            .foregroundStyle(.red)
                            .padding(.horizontal, 16)
                    }

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
            .task {
                await viewModel.loadCitiesIfNeeded()
            }
            .fullScreenCover(isPresented: $isStoriesPresented, onDismiss: {
                selectedStoryID = nil
            }) {
                if let id = selectedStoryID {
                    StoriesViewerView(stories: storiesBinding, startStoryID: id)
                } else {
                    Color.black.ignoresSafeArea()
                }
            }
            .navigationDestination(for: MainViewModel.Route.self) { route in
                switch route {
                case .selectCity(let direction):
                    SelectionView(
                        viewModel: SelectionViewModel(
                            title: "Выбор города",
                            items: viewModel.cities,
                            emptyStateText: "Город не найден",
                            itemTitle: { $0.name }
                        ),
                        onItemSelected: { city in
                            viewModel.didSelectCity(city, for: direction)
                        }
                    )
                    .toolbar(.hidden, for: .tabBar)

                case .selectStation(let direction, let city):
                    SelectionView(
                        viewModel: SelectionViewModel(
                            title: "Выбор станции",
                            items: city.stations,
                            emptyStateText: "Станция не найдена",
                            itemTitle: { $0.title }
                        ),
                        onItemSelected: { station in
                            viewModel.didSelectStation(station, direction: direction)
                        }
                    )
                    .toolbar(.hidden, for: .tabBar)

                case .carriersList(let title, let from, let to):
                    let vm = viewModel.makeCarriersListViewModel(
                        title: title,
                        from: from,
                        to: to
                    )
                    CarriersListView(viewModel: vm)
                        .toolbar(.hidden, for: .tabBar)

                case .error(let errorType):
                    ErrorView(viewModel: ErrorViewModel(errorType: errorType))
                        .toolbar(.hidden, for: .tabBar)
                }
            }
        }
    }
}

#Preview {
    MainView()
}
