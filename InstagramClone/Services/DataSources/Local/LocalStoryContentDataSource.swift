final class LocalStoryContentDataSource: StoryContentDataSource {
    private var cachedContent: [Int: StoryContent] = [:]
    
    func getStoryContent(for userId: Int) async throws -> StoryContent {
        guard let content = cachedContent[userId] else {
            throw CacheError.notFound
        }
        return content
    }
    
    func saveStoryContent(_ content: StoryContent, for userId: Int) {
        cachedContent[userId] = content
    }
    
    enum CacheError: Error {
        case notFound
    }
}
