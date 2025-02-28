import Resolver

import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        // MARK: - Infrastructure
        register { NetworkUtility() }
            .implements(NetworkUtilityProtocol.self)
            .scope(.application)

        // MARK: - Data Sources
        // Local Data Sources
        register { LocalUserDataSource() }
            .scope(.application)

        register { LocalStoryContentDataSource() }
            .scope(.application)

        register { LocalStoryStateDataSource() }
            .scope(.application)

        // Remote Data Sources
        register {
            RemoteUserDataSource()
        }.scope(.application)

        register { resolver in
            RemoteStoryContentDataSource(remoteService: resolver.resolve())
        }.scope(.application)

        // MARK: - Repositories
        register { resolver in
            UserRepository(
                remoteDataSource: resolver.resolve(RemoteUserDataSource.self),
                localDataSource: resolver.resolve(LocalUserDataSource.self)
            )
        }.implements(UserRepositoryProtocol.self)
            .scope(.application)

        register { resolver in
            StoryContentRepository(
                remoteDataSource: resolver.resolve(RemoteStoryContentDataSource.self),
                localDataSource: resolver.resolve(LocalStoryContentDataSource.self)
            )
        }.implements(StoryContentRepositoryProtocol.self)
            .scope(.application)

        register { resolver in
            StoryStateRepository(
                dataSource: resolver.resolve(LocalStoryStateDataSource.self)
            )
        }.implements(StoryStateRepositoryProtocol.self)
            .scope(.application)

        // MARK: - Use Cases
        register { resolver in
            LoadInitialStoriesUseCase(
                userRepository: resolver.resolve(UserRepositoryProtocol.self),
                storyContentRepository: resolver.resolve(StoryContentRepositoryProtocol.self),
                storyStateRepository: resolver.resolve(StoryStateRepositoryProtocol.self)
            )
        }.implements(LoadInitialStoriesUseCaseProtocol.self)
            .scope(.application)

        register { resolver in
            LoadMoreStoriesUseCase(
                userRepository: resolver.resolve(UserRepositoryProtocol.self),
                storyContentRepository: resolver.resolve(StoryContentRepositoryProtocol.self),
                storyStateRepository: resolver.resolve(StoryStateRepositoryProtocol.self)
            )
        }.implements(LoadMoreStoriesUseCaseProtocol.self)
            .scope(.application)

        register { resolver in
            ToggleStoryLikeUseCase(
                storyStateRepository: resolver.resolve(StoryStateRepositoryProtocol.self)
            )
        }.implements(ToggleStoryLikeUseCaseProtocol.self)
            .scope(.application)

        register { resolver in
            MarkStorySeenUseCase(
                storyStateRepository: resolver.resolve(StoryStateRepositoryProtocol.self)
            )
        }.implements(MarkStorySeenUseCaseProtocol.self)
            .scope(.application)
    }
}
