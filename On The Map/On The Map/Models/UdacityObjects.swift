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

struct StudentData: Codable {
    let student: Student
}

struct Student: Codable {
    let firstName: String
    let lastName: String
    // Add other relevant fields
}
