protocol StoryContentRepositoryProtocol {
    func getStoryContent(for userId: Int) async -> StoryContent
}

final class StoryContentRepository: StoryContentRepositoryProtocol {
    private let remoteDataSource: StoryContentDataSource
    private let localDataSource: LocalStoryContentDataSource
    
    init(remoteDataSource: StoryContentDataSource, localDataSource: LocalStoryContentDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func getStoryContent(for userId: Int) async -> StoryContent {
        do {
            return try await localDataSource.getStoryContent(for: userId)
        } catch {
            do {
                let content = try await remoteDataSource.getStoryContent(for: userId)
                localDataSource.saveStoryContent(content, for: userId)
                return content
            } catch {
                print("Error fetching content: \(error). Using fallback.")
                let fallbackContent = createFallbackContent(for: userId)
                localDataSource.saveStoryContent(fallbackContent, for: userId)
                return fallbackContent
            }
        }
    }
    
    private func createFallbackContent(for userId: Int) -> StoryContent {
        let seed = "user\(userId)"
        let imageUrl = "https://picsum.photos/seed/\(seed)/800/1200"
        return StoryContent(id: "fallback-\(userId)", imageUrl: imageUrl)
    }
}
