import Resolver
import SwiftUI

@MainActor
final class StoriesListViewModel: ObservableObject {
    @Published private(set) var stories: [Story] = []
    @Published var isLoading = false

    private let loadInitialStoriesUseCase: LoadInitialStoriesUseCaseProtocol
    private let loadMoreStoriesUseCase: LoadMoreStoriesUseCaseProtocol
    private let toggleStoryLikeUseCase: ToggleStoryLikeUseCaseProtocol
    private let markStorySeenUseCase: MarkStorySeenUseCaseProtocol

    private var currentPage = 0

    init(
        loadInitialStoriesUseCase: LoadInitialStoriesUseCaseProtocol,
        loadMoreStoriesUseCase: LoadMoreStoriesUseCaseProtocol,
        toggleStoryLikeUseCase: ToggleStoryLikeUseCaseProtocol,
        markStorySeenUseCase: MarkStorySeenUseCaseProtocol
    ) {
        self.loadInitialStoriesUseCase = loadInitialStoriesUseCase
        self.loadMoreStoriesUseCase = loadMoreStoriesUseCase
        self.toggleStoryLikeUseCase = toggleStoryLikeUseCase
        self.markStorySeenUseCase = markStorySeenUseCase

        Task {
            await loadInitialData()
        }
    }

    convenience init() {
        self.init(
            loadInitialStoriesUseCase: Resolver.resolve(),
            loadMoreStoriesUseCase: Resolver.resolve(),
            toggleStoryLikeUseCase: Resolver.resolve(),
            markStorySeenUseCase: Resolver.resolve()
        )
    }

    private func loadInitialData() async {
            guard !isLoading else { return }

            isLoading = true
            defer { isLoading = false }

            do {
                stories = try await loadInitialStoriesUseCase.execute()
            } catch {
                print("❌ Error loading initial data: \(error)")
            }
        }

    func loadMoreStories() async {
        guard !isLoading else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            currentPage += 1
            let newStories = try await loadMoreStoriesUseCase.execute(page: currentPage)
            stories.append(contentsOf: newStories)
        } catch {
            print("❌ Error loading more stories: \(error)")
            currentPage -= 1
        }
    }

    func toggleLike(for storyId: String) {
        Task {
            await toggleStoryLikeUseCase.execute(storyId: storyId)
            if let index = stories.firstIndex(where: { $0.id == storyId }) {
                stories[index].isLiked.toggle()
            }
        }
    }

    func markStorySeen(_ storyId: String) {
        Task {
            await markStorySeenUseCase.execute(storyId: storyId)
            if let index = stories.firstIndex(where: { $0.id == storyId }) {
                stories[index].isSeen = true
            }
        }
    }
}
