protocol UserRepositoryProtocol {
    func getUsers(page: Int) async throws -> [User]
}

final class UserRepository: UserRepositoryProtocol {
    private let remoteDataSource: UserDataSource
    private let localDataSource: LocalUserDataSource
    
    init(remoteDataSource: UserDataSource, localDataSource: LocalUserDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func getUsers(page: Int) async throws -> [User] {
        do {
            return try await localDataSource.getUsers(page: page)
        } catch {
            do {
                let users = try await remoteDataSource.getUsers(page: page)
                localDataSource.saveUsers(users, forPage: page)
                return users
            } catch {
                throw error
            }
        }
    }
}
