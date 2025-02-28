protocol StoryStateRepositoryProtocol {
    var likedStoriesIds: Set<String> { get }
    var seenStoriesIds: Set<String> { get }
    func toggleStoryLike(_ storyId: String)
    func markStorySeen(_ storyId: String)
}

final class StoryStateRepository: StoryStateRepositoryProtocol {
    private let dataSource: StoryStateDataSource
    
    init(dataSource: StoryStateDataSource) {
        self.dataSource = dataSource
    }
    
    var likedStoriesIds: Set<String> {
        dataSource.likedStoriesIds
    }
    
    var seenStoriesIds: Set<String> {
        dataSource.seenStoriesIds
    }
    
    func toggleStoryLike(_ storyId: String) {
        dataSource.toggleStoryLike(storyId)
    }
    
    func markStorySeen(_ storyId: String) {
        dataSource.markStorySeen(storyId)
    }
}
