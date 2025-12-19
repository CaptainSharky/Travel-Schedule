import SwiftUI

struct StoriesRowView: View {
    let stories: [StoryPreview]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(stories) { story in
                    StoryPreviewCellView(story: story)
                        .onTapGesture { }
                }
            }
        }
        .contentMargins(.horizontal, 16, for: .scrollContent)
        .frame(height: 140)
        .background(Color(.ypWhiteDay))
    }
}


#Preview {
    StoriesRowView(stories: StoryPreview.mock)
}
