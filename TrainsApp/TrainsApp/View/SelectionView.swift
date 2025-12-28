import SwiftUI

struct SelectionView<Item: Identifiable & Hashable>: View {
    @State private var viewModel: SelectionViewModel<Item>
    let onItemSelected: (Item) -> Void

    @Environment(\.dismiss) private var dismiss

    init(
        viewModel: SelectionViewModel<Item>,
        onItemSelected: @escaping (Item) -> Void
    ) {
        _viewModel = State(initialValue: viewModel)
        self.onItemSelected = onItemSelected
    }

    var body: some View {
        List {
            ForEach(viewModel.filteredItems) { item in
                Button {
                    onItemSelected(item)
                } label: {
                    HStack {
                        Text(viewModel.itemTitle(item))
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
        .overlay {
            if viewModel.shouldShowEmptyState {
                Text(viewModel.emptyStateText)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color(.ypBlackDay))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .allowsHitTesting(false)
            }
        }
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
