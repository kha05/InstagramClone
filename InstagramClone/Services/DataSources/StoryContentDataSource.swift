protocol StoryContentDataSource {
    func getStoryContent(for userId: Int) async throws -> StoryContent
}
