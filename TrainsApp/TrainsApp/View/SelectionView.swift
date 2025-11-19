import SwiftUI

struct SelectionView: View {
    @State private var viewModel: SelectionViewModel
    let onItemSelected: (String) -> Void

    @Environment(\.dismiss) private var dismiss

    init(
        viewModel: SelectionViewModel,
        onItemSelected: @escaping (String) -> Void
    ) {
        _viewModel = State(initialValue: viewModel)
        self.onItemSelected = onItemSelected
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        List {
            ForEach(viewModel.filteredItems, id: \.self) { item in
                Button {
                    onItemSelected(item)
                } label: {
                    HStack {
                        Text(item)
                            .font(.system(size: 17))
                            .foregroundStyle(.ypBlackDay)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.ypBlackDay)
                    }
                    .frame(height: 40)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .listRowSeparator(.hidden)
                .listRowBackground(Color(.ypWhiteDay))
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color(.ypWhiteDay))
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
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
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Введите запрос"
        )
        .textInputAutocapitalization(.never)
    }
}

#Preview {
    NavigationStack {
        SelectionView(
            viewModel: SelectionViewModel(
                title: "Выбор города",
                items: [
                    "Москва",
                    "Санкт Петербург",
                    "Сочи",
                    "Горный воздух",
                    "Краснодар",
                    "Казань",
                    "Омск"
                ]
            ),
            onItemSelected: { _ in }
        )
    }
}
