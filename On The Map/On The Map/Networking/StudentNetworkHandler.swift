import Foundation

class StudentNetworkHandler {
    
    static let shared = StudentNetworkHandler()

    func fetchStudents() async throws -> StudentList {
        let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt&limit=100"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "UdacityAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        return try await NetworkingUtility.performDecodableRequest(url: url)
    }
    
    func postStudentLocation(studentLocation: StudentLocationRequest) async throws -> StudentLocationResponse {
        let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "UdacityAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(studentLocation)
        
        // Use the NetworkingUtility to perform the POST request
        return try await NetworkingUtility.performDecodableRequest(url: url, httpMethod: "POST", body: jsonData)
    }
}
