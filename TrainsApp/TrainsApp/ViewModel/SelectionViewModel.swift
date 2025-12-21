import Foundation
import Observation

@MainActor
@Observable final class SelectionViewModel<Item: Identifiable & Hashable> {

    let title: String
    let items: [Item]
    let emptyStateText: String
    let itemTitle: (Item) -> String

    var searchText: String = ""

    var filteredItems: [Item] {
        guard !searchText.isEmpty else { return items }
        return items.filter { item in
            itemTitle(item).localizedCaseInsensitiveContains(searchText)
        }
    }

    var shouldShowEmptyState: Bool {
        filteredItems.isEmpty && !searchText.isEmpty
    }

    init(
        title: String,
        items: [Item],
        emptyStateText: String,
        itemTitle: @escaping (Item) -> String
    ) {
        self.title = title
        self.items = items
        self.emptyStateText = emptyStateText
        self.itemTitle = itemTitle
    }
}
