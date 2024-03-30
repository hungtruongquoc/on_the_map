import Foundation

class StudentNetworkHandler {
    
    static let shared = StudentNetworkHandler()

    func fetchStudents() async throws -> StudentList {
        let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt&limit=100"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "UdacityAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        var request = URLRequest(url: url)
        print("Sending request to URL: \(urlString)")
        print("HTTP Method: \(request.httpMethod ?? "N/A")")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        print("Received response from URL: \(urlString)")
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "UdacityAPI", code: -2, userInfo: [NSLocalizedDescriptionKey: "No valid HTTP response"])
        }
        
        print("HTTP Status Code: \(httpResponse.statusCode)")
        guard httpResponse.statusCode == 200 else {
            throw NSError(domain: "UdacityAPI", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Received unexpected status code: \(httpResponse.statusCode)"])
        }
        
        // Optionally log the raw response data string
        if let responseDataString = String(data: data, encoding: .utf8) {
            print("Raw Response Data String: \(responseDataString.prefix(500))") // Print the first 500 characters to avoid overwhelming the console
        }
        
        let decoder = JSONDecoder()
        let studentList = try decoder.decode(StudentList.self, from: data)
        return studentList
    }
}
