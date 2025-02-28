import Foundation

final class RemoteUserDataSource: UserDataSource {
    func getUsers(page: Int) async throws -> [User] {
            guard let url = Bundle.main.url(forResource: "users", withExtension: "json") else {
                print("❌ JSON file not found")
                throw DataError.fileNotFound
            }

            do {
                let data = try Data(contentsOf: url)
                let response = try JSONDecoder().decode(UsersResponseDTO.self, from: data)

                guard page < response.pages.count else {
                    print("❌ Page \(page) not found")
                    return []
                }

                let users = response.pages[page].users
                return users.map { $0.toDomain() }

            } catch {
                print("❌ Error decoding JSON: \(error)")
                throw error
            }
        }

    enum DataError: Error {
        case fileNotFound
    }
}
