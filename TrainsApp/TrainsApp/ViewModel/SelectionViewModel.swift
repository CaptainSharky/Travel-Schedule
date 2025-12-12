import Foundation
import Observation

@Observable final class SelectionViewModel {
    let title: String
    let items: [String]
    var searchText: String = ""
    let emptyStateText: String

    var filteredItems: [String] {
        guard !searchText.isEmpty else { return items }
        return items.filter {
            $0.localizedCaseInsensitiveContains(searchText)
        }
    }

    var shouldShowEmptyState: Bool {
        filteredItems.isEmpty && !searchText.isEmpty
    }

    init(title: String, items: [String], emptyStateText: String) {
        self.title = title
        self.items = items
        self.emptyStateText = emptyStateText
    }
}
