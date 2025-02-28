import SwiftUI
import Kingfisher

struct StoryPreviewView: View {
    let story: Story

    private let instagramGradient = LinearGradient(
        colors: [
            Color(red: 0.96, green: 0.15, blue: 0.42),
            Color(red: 0.96, green: 0.56, blue: 0.34),
            Color(red: 0.94, green: 0.20, blue: 0.52),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    var body: some View {
        VStack {
            ZStack {
                Group {
                    if story.isSeen {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 2.5)
                    } else {
                        Circle()
                            .fill(instagramGradient)
                    }
                }
                .frame(width: 74, height: 74)
                
                Circle()
                    .fill(Color(.systemBackground))
                    .frame(width: 70, height: 70)
                
                KFImage(URL(string: story.user.profilePictureUrl))
                    .placeholder {
                        ProgressView()
                    }
                    .fade(duration: 0.25)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 66, height: 66)
                    .clipShape(Circle())
            }
            
            Text(story.user.name)
                .font(.caption)
                .lineLimit(1)
                .frame(width: 80)
        }
        .padding(.horizontal, 4)
    }
}
