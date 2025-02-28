import Foundation

protocol LoadMoreStoriesUseCaseProtocol {
    func execute(page: Int) async throws -> [Story]
}

final class LoadMoreStoriesUseCase: LoadMoreStoriesUseCaseProtocol {
    private let userRepository: UserRepositoryProtocol
    private let storyContentRepository: StoryContentRepositoryProtocol
    private let storyStateRepository: StoryStateRepositoryProtocol
    
    init(
        userRepository: UserRepositoryProtocol,
        storyContentRepository: StoryContentRepositoryProtocol,
        storyStateRepository: StoryStateRepositoryProtocol
    ) {
        self.userRepository = userRepository
        self.storyContentRepository = storyContentRepository
        self.storyStateRepository = storyStateRepository
    }
    
    func execute(page: Int) async throws -> [Story] {
        let users = try await userRepository.getUsers(page: page)
        var stories: [Story] = []
        
        for user in users {
            let storyId = UUID().uuidString
            let content = await storyContentRepository.getStoryContent(for: user.id)
            
            let story = Story(
                id: storyId,
                user: user,
                content: content,
                isLiked: storyStateRepository.likedStoriesIds.contains(storyId),
                isSeen: storyStateRepository.seenStoriesIds.contains(storyId),
                timestamp: Date()
            )
            
            stories.append(story)
        }
        
        return stories
    }
}
