import Foundation

struct Story: Identifiable, Hashable {
    let id: UUID
    let imageName: String
    let title: String
    let description: String
    var isViewed: Bool
}

extension Story {
    static let mock: [Story] = [
        .init(id: UUID(), imageName: "story_1", title: text, description: text, isViewed: false),
        .init(id: UUID(), imageName: "story_2", title: "История 2", description: "Описание истории 2", isViewed: false),
        .init(id: UUID(), imageName: "story_3", title: "История 3", description: "Описание истории 3", isViewed: false),
        .init(id: UUID(), imageName: "story_4", title: "История 4", description: "Описание истории 4", isViewed: false),
        .init(id: UUID(), imageName: "story_5", title: "История 5", description: "Описание истории 5", isViewed: false),
        .init(id: UUID(), imageName: "story_6", title: "История 6", description: "Описание истории 6", isViewed: false),
        .init(id: UUID(), imageName: "story_7", title: "История 7", description: "Описание истории 7", isViewed: true)
    ]

    static let text = "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text "
}
