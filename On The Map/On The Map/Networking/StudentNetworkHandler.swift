import Foundation

class StudentNetworkHandler {
    
    static let shared = StudentNetworkHandler()

    func fetchStudents(completion: @escaping (StudentList?, Error?) -> Void) {
        let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt&limit=100"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "UdacityAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }

        let request = URLRequest(url: url)
        
        // Log the request information
        print("Sending request to URL: \(urlString)")
        print("HTTP Method: \(request.httpMethod ?? "N/A")")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            // Log when the data is received
            print("Received response from URL: \(urlString)")
            
            if let error = error {
                // Log error
                print("Error fetching students: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                // Log the status code
                print("HTTP Status Code: \(httpResponse.statusCode)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                let statusError = NSError(domain: "UdacityAPI", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Received unexpected status code: \(statusCode)"])
                DispatchQueue.main.async {
                    completion(nil, statusError)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, NSError(domain: "UdacityAPI", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                }
                return
            }

            // Optionally log the raw response data string
            if let responseDataString = String(data: data, encoding: .utf8) {
                print("Raw Response Data String: \(responseDataString.prefix(500))") // Print the first 500 characters to avoid overwhelming the console
            }

            do {
                let decoder = JSONDecoder()
                let studentList = try decoder.decode(StudentList.self, from: data)
                DispatchQueue.main.async {
                    completion(studentList, nil)
                }
            } catch let decodeError {
                // Log decoding error
                print("Error decoding student list: \(decodeError.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil, decodeError)
                }
            }
        }
        task.resume()
    }
}
