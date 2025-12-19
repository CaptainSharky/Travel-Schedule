import SwiftUI

struct StoryView: View {
    let story: Story

    var body: some View {
        ZStack {
            Image(story.imageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 10) {
                    Text(story.title)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.ypWhite)
                        .lineLimit(2)

                    Text(story.description)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(.ypWhite)
                        .lineLimit(3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    StoryView(story: .mock[0])
}
