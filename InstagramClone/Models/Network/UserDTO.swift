import Foundation

struct UserDTO: Codable {
    let id: Int
    let name: String
    let profilePictureUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePictureUrl = "profile_picture_url"
    }

    func toDomain() -> User {
        return User(
            id: id,
            name: name,
            profilePictureUrl: profilePictureUrl
        )
    }
}
