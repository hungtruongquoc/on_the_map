// Define the structures to match the JSON response

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct UserResponse: Codable {
    let user: User
}

struct User: Codable {
    let lastName: String
    let firstName: String
    let key: String
    let nickname: String
    let email: UserEmail
    let imageUrl: String?
    
    // Add other properties as needed...
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
        case key
        case nickname
        case email
        case imageUrl = "_image_url"
    }
}

struct UserEmail: Codable {
    let address: String
    let verified: Bool
    
    enum CodingKeys: String, CodingKey {
        case address
        case verified = "_verified"
    }
}

// Root structure for the delete session response
struct DeleteSessionResponse: Codable {
    let session: SessionDetail
}

// Details about the session that was deleted
struct SessionDetail: Codable {
    let id: String
    let expiration: String
}

