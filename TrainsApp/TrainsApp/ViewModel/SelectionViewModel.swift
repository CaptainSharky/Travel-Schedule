import Foundation
import Observation

@Observable final class SelectionViewModel {
    let title: String
    let items: [String]
    var searchText: String = ""

    var filteredItems: [String] {
        guard !searchText.isEmpty else { return items }
        return items.filter {
            $0.localizedCaseInsensitiveContains(searchText)
        }
    }

    init(title: String, items: [String]) {
        self.title = title
        self.items = items
    }
}
