import Foundation

struct NetworkingUtility {
    
    enum NetworkError: Error {
        case invalidResponse
        case statusCode(Int)
    }

    // Method for handling decodable responses
    static func performDecodableRequest<T: Decodable>(url: URL,
                                                      httpMethod: String = "GET",
                                                      body: Data? = nil,
                                                      headers: [String: String]? = nil,
                                                      rangeOffset: Int? = nil) async throws -> T {
        var request = URLRequest(url: url)
        configureRequest(&request, withMethod: httpMethod, body: body, headers: headers)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.statusCode((response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        
        print(httpResponse)
        print(data)
        
        let newData = processData(data, withOffset: rangeOffset)
        return try decode(newData)
    }

    // Method for handling raw data responses
    static func performDataRequest(url: URL,
                                   httpMethod: String,
                                   body: Data? = nil,
                                   headers: [String: String]? = nil) async throws -> Data {
        var request = URLRequest(url: url)
        configureRequest(&request, withMethod: httpMethod, body: body, headers: headers)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.statusCode((response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        
        // Directly return data without decoding
        return data
    }
    
    // Helper method to configure URLRequest
    private static func configureRequest(_ request: inout URLRequest, withMethod httpMethod: String, body: Data?, headers: [String: String]?) {
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        request.httpBody = body
    }
    
    // Helper method to process data with optional offset
    private static func processData(_ data: Data, withOffset rangeOffset: Int?) -> Data {
        guard let rangeOffset = rangeOffset else { return data }
        return data.subdata(in: rangeOffset..<data.count)
    }
    
    // Helper method to decode Data into Decodable object
    private static func decode<T: Decodable>(_ data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
