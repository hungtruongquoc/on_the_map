import Foundation

class UdacityNetworkHandler {
    
    static let shared = UdacityNetworkHandler()
    
    func login(username: String, password: String, completion: @escaping (Bool, LoginResponse?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["udacity": ["username": username, "password": password]]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(false, nil, error) // Ensure completion matches expected signature
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(false, nil, error ?? NSError(domain: "loginError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown network error"])) // Provide an NSError if error is nil
                }
                return
            }
            
            if httpResponse.statusCode == 200 {
                let range = 5..<data.count
                let newData = data.subdata(in: range) // Use the subset of the response data
                do {
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(LoginResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(true, responseObject, nil) // Success case
                    }
                } catch let decodeError {
                    DispatchQueue.main.async {
                        completion(false, nil, decodeError) // Decoding error
                    }
                }
            } else {
                // Custom error for non-200 status codes
                let statusError = NSError(domain: "loginError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed with status code: \(httpResponse.statusCode)"])
                DispatchQueue.main.async {
                    completion(false, nil, statusError) // HTTP error
                }
            }
        }
        task.resume()
    }
    
    func fetchUserInfo(userId: String, completion: @escaping (User?, Error?) -> Void) {
        let urlString = "https://onthemap-api.udacity.com/v1/users/\(userId)"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "InvalidURL", code: 1, userInfo: nil))
            return
        }

        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }

            let range = 5..<data.count
            let newData = data.subdata(in: range)
            do {
                let decoder = JSONDecoder()
                let userData = try decoder.decode(UserResponse.self, from: newData)
                DispatchQueue.main.async {
                    completion(userData.user, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}
