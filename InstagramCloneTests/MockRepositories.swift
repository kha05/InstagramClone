@testable import InstagramClone

final class MockUserRepository: UserRepositoryProtocol {
    var users: [User] = []
    var getUsersCallCount = 0
    var error: Error?

    func getUsers(page: Int) async throws -> [User] {
        getUsersCallCount += 1
        if let error = error {
            throw error
        }
        return users
    }
}

final class MockStoryContentRepository: StoryContentRepositoryProtocol {
    var content: StoryContent?
    var getContentCallCount = 0

    func getStoryContent(for userId: Int) async -> StoryContent {
        getContentCallCount += 1
        return content ?? StoryContent(id: "mock", imageUrl: "mock-url")
    }
}

final class MockStoryStateRepository: StoryStateRepositoryProtocol {
    var likedStoriesIds: Set<String> = []
    var seenStoriesIds: Set<String> = []
    var toggleLikeCallCount = 0
    var markSeenCallCount = 0

    func toggleStoryLike(_ storyId: String) {
        toggleLikeCallCount += 1
        if likedStoriesIds.contains(storyId) {
            likedStoriesIds.remove(storyId)
        } else {
            likedStoriesIds.insert(storyId)
        }
    }

    func markStorySeen(_ storyId: String) {
        markSeenCallCount += 1
        seenStoriesIds.insert(storyId)
    }
}
