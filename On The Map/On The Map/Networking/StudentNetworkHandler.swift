import Foundation

class StudentNetworkHandler {
    
    static let shared = StudentNetworkHandler()

    func fetchStudents() async throws -> StudentList {
        let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt&limit=100"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "UdacityAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        return try await NetworkingUtility.performNetworkRequest(url: url)
    }
}
