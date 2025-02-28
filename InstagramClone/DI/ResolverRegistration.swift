import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        // Network
        register { NetworkUtility() as NetworkUtilityProtocol }
            .scope(.application)

        // Data Sources
        register { resolver in
            RemoteUserDataSource()
        }

        register { LocalUserDataSource() }
            .scope(.application)

        register { resolver in
            RemoteStoryContentDataSource(remoteService: resolver.resolve())
        }

        register { LocalStoryContentDataSource() }
            .scope(.application)

        register { LocalStoryStateDataSource() as StoryStateDataSource }
            .scope(.application)

        // Repositories
        register { resolver in
            UserRepository(
                remoteDataSource: resolver.resolve(RemoteUserDataSource.self),
                localDataSource: resolver.resolve()
            )
        }.scope(.application)

        register { resolver in
            StoryContentRepository(
                remoteDataSource: resolver.resolve(RemoteStoryContentDataSource.self),
                localDataSource: resolver.resolve()
            )
        }.scope(.application)

        register { resolver in
            StoryStateRepository(dataSource: resolver.resolve())
        }.scope(.application)

        // Use cases
        register { resolver in
            LoadDataUseCase(userRepository: resolver.resolve())
        }.scope(.application)
    }
}
