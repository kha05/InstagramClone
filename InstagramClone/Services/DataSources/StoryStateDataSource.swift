protocol StoryStateDataSource {
    var likedStoriesIds: Set<String> { get }
    var seenStoriesIds: Set<String> { get }

    func toggleStoryLike(_ storyId: String)
    func markStorySeen(_ storyId: String)
}
