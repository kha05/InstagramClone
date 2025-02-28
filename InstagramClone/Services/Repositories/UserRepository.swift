protocol UserRepositoryProtocol {
    func getUsers(page: Int) async throws -> [User]
}

final class UserRepository: UserRepositoryProtocol {
    private let remoteDataSource: RemoteUserDataSource
    private let localDataSource: LocalUserDataSource
    
    init(remoteDataSource: RemoteUserDataSource, localDataSource: LocalUserDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func getUsers(page: Int) async throws -> [User] {
        let cachedUsers = localDataSource.getUsers(page: page)
        if cachedUsers.isEmpty {
            do {
                let users = try await remoteDataSource.getUsers(page: page)
                localDataSource.saveUsers(users, forPage: page)
                return users
            } catch {
                throw error
            }
        } else {
            return cachedUsers
        }
    }
}
