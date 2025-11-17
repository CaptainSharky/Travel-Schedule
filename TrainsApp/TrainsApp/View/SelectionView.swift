import SwiftUI

struct SelectionView: View {
    let title: String
    let items: [String]
    let onItemSelected: (String) -> Void

    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss

    private var filteredItems: [String] {
        guard !searchText.isEmpty else { return items }
        return items.filter {
            $0.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        List {
            ForEach(filteredItems, id: \.self) { item in
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
        .navigationTitle(title)
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
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Введите запрос"
        )
        .textInputAutocapitalization(.never)
    }
}

#Preview {
    NavigationStack {
        SelectionView(
            title: "Выбор города",
            items: [
                "Москва",
                "Санкт Петербург",
                "Сочи",
                "Горный воздух",
                "Краснодар",
                "Казань",
                "Омск"
            ],
            onItemSelected: { _ in }
        )
    }
}
