import Foundation

class UdacityNetworkHandler {
    
    static let shared = UdacityNetworkHandler()
    
    func login(username: String, password: String) async throws -> LoginResponse {
        guard let url = URL(string: "https://onthemap-api.udacity.com/v1/session") else {
            throw NSError(domain: "InvalidURL", code: 1, userInfo: nil)
        }
        
        let bodyDict = ["udacity": ["username": username, "password": password]]
        let body = try JSONSerialization.data(withJSONObject: bodyDict, options: [])
        
        return try await NetworkingUtility.performNetworkRequest(url: url, httpMethod: "POST", body: body, rangeOffset: 5)
    }
        
    func fetchUserInfo(userId: String) async throws -> User {
        guard let url = URL(string: "https://onthemap-api.udacity.com/v1/users/\(userId)") else {
            throw NSError(domain: "InvalidURL", code: 1, userInfo: nil)
        }
        
        return try await NetworkingUtility.performNetworkRequest(url: url, rangeOffset: 5)
    }
}
