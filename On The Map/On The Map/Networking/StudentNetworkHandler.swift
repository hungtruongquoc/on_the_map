import Foundation

class StudentNetworkHandler {
    
    static let shared = StudentNetworkHandler()

    func fetchStudents(completion: @escaping (StudentList?, Error?) -> Void) {
        let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "UdacityAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }

        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
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

            // Skip the first 5 characters of the response data for Udacity's API
            let newData = data.subdata(in: 5..<data.count)

            do {
                let decoder = JSONDecoder()
                let studentList = try decoder.decode(StudentList.self, from: newData)
                DispatchQueue.main.async {
                    completion(studentList, nil)
                }
            } catch let decodeError {
                DispatchQueue.main.async {
                    completion(nil, decodeError)
                }
            }
        }
        task.resume()
    }
}
