import Foundation

final class RemoteUserDataSource: UserDataSource {
    func getUsers(page: Int) async throws -> [User] {
        guard let url = Bundle.main.url(forResource: "users", withExtension: "json") else {
            throw DataError.fileNotFound
        }
        
        let data = try Data(contentsOf: url)
        let response = try JSONDecoder().decode(UsersResponseDTO.self, from: data)
        
        guard page < response.pages.count else {
            return []
        }
        
        return response.pages[page].users.map { $0.toDomain() }
    }
    
    enum DataError: Error {
        case fileNotFound
    }
}
