import Foundation

class UdacityNetworkHandler {
    
    static let shared = UdacityNetworkHandler()
    
    func login(username: String, password: String) async throws -> LoginResponse {
        guard let url = URL(string: "https://onthemap-api.udacity.com/v1/session") else {
            throw NSError(domain: "InvalidURL", code: 1, userInfo: nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["udacity": ["username": username, "password": password]]
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            throw NSError(domain: "loginError", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed with status code: \(statusCode)"])
        }
        
        let range = 5..<data.count
        let newData = data.subdata(in: range) // Use the subset of the response data
        
        let decoder = JSONDecoder()
        let responseObject = try decoder.decode(LoginResponse.self, from: newData)
        return responseObject
    }
    
    func fetchUserInfo(userId: String) async throws -> User {
        guard let url = URL(string: "https://onthemap-api.udacity.com/v1/users/\(userId)") else {
            throw NSError(domain: "InvalidURL", code: 1, userInfo: nil)
        }

        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let range = 5..<data.count
        let newData = data.subdata(in: range)
        
        let decoder = JSONDecoder()
        let userData = try decoder.decode(User.self, from: newData)
        return userData
    }
}
