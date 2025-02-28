final class LocalUserDataSource: UserDataSource {
    private var cachedUsers: [[User]] = []
    
    func getUsers(page: Int) async throws -> [User] {
        guard page < cachedUsers.count else {
            return []
        }
        return cachedUsers[page]
    }
    
    func saveUsers(_ users: [User], forPage page: Int) {
        if page >= cachedUsers.count {
            for _ in cachedUsers.count...page {
                cachedUsers.append([])
            }
        }
        cachedUsers[page] = users
    }
}
