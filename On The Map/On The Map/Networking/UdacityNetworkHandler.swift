import Foundation

class UdacityNetworkHandler {
    
    static let shared = UdacityNetworkHandler()
    
    func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["udacity": ["username": username, "password": password]]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(false, error)
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, error)
                return
            }
            
            let statusCode = httpResponse.statusCode
            DispatchQueue.main.async {
                if statusCode == 200 {
                    completion(true, nil)
                } else {
                    // You can create a custom error based on the status code if needed
                    let error = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed with status code: \(statusCode)"])
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
}
