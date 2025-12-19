import SwiftUI

struct StoriesRowView: View {
    let stories: [Story]
    let onTapStory: (Story) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(stories) { story in
                    StoryPreviewCellView(story: story)
                        .onTapGesture {
                            onTapStory(story)
                        }
                }
            }
        }
        .contentMargins(.horizontal, 16, for: .scrollContent)
        .frame(height: 140)
        .background(Color(.ypWhiteDay))
    }
}


#Preview {
    StoriesRowView(stories: Story.mock, onTapStory: { _ in })
}
