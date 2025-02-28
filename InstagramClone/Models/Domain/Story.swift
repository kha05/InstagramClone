import Foundation

struct Story: Identifiable {
    let id: String
    let user: User
    let content: StoryContent
    var isLiked: Bool
    var isSeen: Bool
    let timestamp: Date

    init(
        id: String = UUID().uuidString,
        user: User,
        content: StoryContent,
        isLiked: Bool = false,
        isSeen: Bool = false,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.user = user
        self.content = content
        self.isLiked = isLiked
        self.isSeen = isSeen
        self.timestamp = timestamp
    }
}
