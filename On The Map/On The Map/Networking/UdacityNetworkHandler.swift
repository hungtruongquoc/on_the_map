import Foundation

class UdacityNetworkHandler {
    
    static let shared = UdacityNetworkHandler()
    
    func login(username: String, password: String) async throws -> LoginResponse {
        guard let url = URL(string: "https://onthemap-api.udacity.com/v1/session") else {
            throw NSError(domain: "InvalidURL", code: 1, userInfo: nil)
        }
        
        let bodyDict = ["udacity": ["username": username, "password": password]]
        let body = try JSONSerialization.data(withJSONObject: bodyDict, options: [])
        
        // Correctly specify the expected return type to let Swift infer the generic parameter `T`.
        return try await NetworkingUtility.performDecodableRequest(
            url: url,
            httpMethod: "POST",
            body: body,
            rangeOffset: 5
        )
    }
        
    func fetchUserInfo(userId: String) async throws -> User {
        guard let url = URL(string: "https://onthemap-api.udacity.com/v1/users/\(userId)") else {
            throw NSError(domain: "InvalidURL", code: 1, userInfo: nil)
        }
        
        // Again, specify the expected return type directly.
        return try await NetworkingUtility.performDecodableRequest(
            url: url,
            rangeOffset: 5
        )
    }
    

    // Modify the logout function to return raw Data from the logout request.
    func logout() async throws -> Data? {
        guard let url = URL(string: "https://onthemap-api.udacity.com/v1/session") else {
            throw NSError(domain: "UdacityAPIError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL for logout"])
        }
        
        // Prepare headers, including the XSRF token if available.
        var headers = [String: String]()
        if let xsrfCookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == "XSRF-TOKEN" }) {
            headers["X-XSRF-TOKEN"] = xsrfCookie.value
        }
        
        // Use the performNetworkRequest method that handles non-decodable responses.
        // Since logout might still return a simple JSON structure, we're using a Data? return type but not decoding it.
        let responseData: Data? = try await NetworkingUtility.performDataRequest(
            url: url,
            httpMethod: "DELETE",
            headers: headers
        )
        
        // Optional: Process the responseData if needed, or just confirm logout was successful.
        return responseData
    }
}
