final class RemoteStoryContentDataSource: StoryContentDataSource {
    private let remoteService: NetworkUtilityProtocol
    private let baseURL = "https://picsum.photos"
    
    init(remoteService: NetworkUtilityProtocol) {
        self.remoteService = remoteService
    }
    
    func getStoryContent(for userId: Int) async throws -> StoryContent {
        let seed = "user\(userId)"
        let width = 800
        let height = 1200
        let imageUrl = "\(baseURL)/seed/\(seed)/\(width)/\(height)"

        _ = try await remoteService.fetchData(from: imageUrl)

        return StoryContent(
            id: "picsum-\(userId)",
            imageUrl: imageUrl
        )
    }
}
