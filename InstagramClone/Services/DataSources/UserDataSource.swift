protocol UserDataSource {
    func getUsers(page: Int) async throws -> [User]
}
