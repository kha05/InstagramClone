protocol ToggleStoryLikeUseCaseProtocol {
    func execute(storyId: String) async
}

final class ToggleStoryLikeUseCase: ToggleStoryLikeUseCaseProtocol {
    private let storyStateRepository: StoryStateRepositoryProtocol
    
    init(storyStateRepository: StoryStateRepositoryProtocol) {
        self.storyStateRepository = storyStateRepository
    }
    
    func execute(storyId: String) async {
        storyStateRepository.toggleStoryLike(storyId)
    }
}
