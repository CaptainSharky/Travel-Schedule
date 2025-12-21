import SwiftUI

struct StoryPreviewCellView: View {
    let story: Story

    private let cornerRadius: CGFloat = 16
    private let borderWidth: CGFloat = 4

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(story.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 92, height: 140)
                .clipped()

            LinearGradient(
                colors: [
                    Color.black.opacity(0.0),
                    Color.black.opacity(0.55)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(width: 92, height: 140)

            Text(story.title)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(Color(.ypWhite))
                .multilineTextAlignment(.leading)
                .lineLimit(3)
                .padding(8)
        }
        .frame(width: 92, height: 140)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay {
            if !story.isViewed {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(Color(.ypBlue), lineWidth: borderWidth)
            }
        }
        .opacity(story.isViewed ? 0.5 : 1.0)
        .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

#Preview {
    ZStack {
        Color(.ypWhiteDay).ignoresSafeArea()
        HStack(spacing: 12) {
            StoryPreviewCellView(story: Story.mock[0])
            StoryPreviewCellView(story: Story.mock[1])
        }
        .padding()
    }
}
