import Foundation

class UdacityNetworkHandler {
    
    static let shared = UdacityNetworkHandler()
    
    func login(username: String, password: String) async throws -> LoginResponse {
        print("Attempting login for username: \(username)")
        
        guard let url = URL(string: "https://onthemap-api.udacity.com/v1/session") else {
            throw NSError(domain: "InvalidURL", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL for login endpoint"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["udacity": ["username": username, "password": password]]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error serializing login request body: \(error.localizedDescription)")
            throw error
        }
        
        print("Sending login request to URL: \(url)")
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "loginError", code: -2, userInfo: [NSLocalizedDescriptionKey: "No valid HTTP response received"])
        }
        
        print("Received HTTP status code: \(httpResponse.statusCode) for login request")
        guard httpResponse.statusCode == 200 else {
            let statusCode = httpResponse.statusCode
            throw NSError(domain: "loginError", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed with status code: \(statusCode)"])
        }
        
        let range = 5..<data.count
        let newData = data.subdata(in: range) // Skip the first 5 characters of the response data for Udacity's API specific format
        
        do {
            let decoder = JSONDecoder()
            let responseObject = try decoder.decode(LoginResponse.self, from: newData)
            print("Successfully logged in user: \(username)")
            return responseObject
        } catch {
            print("Error decoding login response: \(error.localizedDescription)")
            throw error
        }
    }

    
    func fetchUserInfo(userId: String) async throws -> User {
        print("Fetching user info for userID: \(userId)")
        guard let url = URL(string: "https://onthemap-api.udacity.com/v1/users/\(userId)") else {
            throw NSError(domain: "InvalidURL", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL for userID: \(userId)"])
        }

        print("Constructed URL for fetching user info: \(url)")
        let request = URLRequest(url: url)

        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Optionally, log details about the response
        if let httpResponse = response as? HTTPURLResponse {
            print("Received HTTP status code: \(httpResponse.statusCode)")
        }

        let range = 5..<data.count
        let newData = data.subdata(in: range) // Skips the first 5 characters of the response
        
        // Optionally, log the raw string of the new data for debugging purposes
        if let rawResponseString = String(data: newData, encoding: .utf8) {
            print("Raw response data (truncated): \(rawResponseString.prefix(500))") // Truncate to avoid overwhelming logs
        }

        let decoder = JSONDecoder()
        let userData = try decoder.decode(User.self, from: newData)
        print("Successfully decoded user data for userID: \(userId)")

        return userData
    }
}
