import Foundation

struct UsersResponseDTO: Codable {
    let pages: [Page]
    
    struct Page: Codable {
        let users: [UserDTO]
    }

    func toDomainUsers() -> [[User]] {
        return pages.map { page in
            page.users.map { $0.toDomain() }
        }
    }
}
