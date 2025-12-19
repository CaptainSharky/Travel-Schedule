import Foundation

struct StoryPreview: Identifiable, Hashable {
    let id: UUID
    let imageName: String
    let title: String
    let isViewed: Bool
}

extension StoryPreview {
    static let mock: [StoryPreview] = [
        .init(id: UUID(), imageName: "story_1", title: "Text Text\nText Text\nText Text Text Text Text Text Text Text", isViewed: false),
        .init(id: UUID(), imageName: "story_2", title: "Text Text\nText Text\nText Text ...", isViewed: false),
        .init(id: UUID(), imageName: "story_3", title: "Text Text\nText Text\nText Text ...", isViewed: true),
        .init(id: UUID(), imageName: "story_4", title: "Text Text\nText Text\nText Text ...", isViewed: true),
        .init(id: UUID(), imageName: "story_5", title: "Text Text\nText Text\nText Text ...", isViewed: true),
        .init(id: UUID(), imageName: "story_6", title: "Text Text\nText Text\nText Text ...", isViewed: false),
        .init(id: UUID(), imageName: "story_7", title: "Text Text\nText Text\nText Text ...", isViewed: true)
    ]
}
