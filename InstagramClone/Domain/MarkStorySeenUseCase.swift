protocol MarkStorySeenUseCaseProtocol {
    func execute(storyId: String) async
}

final class MarkStorySeenUseCase: MarkStorySeenUseCaseProtocol {
    private let storyStateRepository: StoryStateRepositoryProtocol
    
    init(storyStateRepository: StoryStateRepositoryProtocol) {
        self.storyStateRepository = storyStateRepository
    }
    
    func execute(storyId: String) async {
        storyStateRepository.markStorySeen(storyId)
    }
}
