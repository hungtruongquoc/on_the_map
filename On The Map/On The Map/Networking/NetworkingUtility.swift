//
//  NetworkingUtility.swift
//  On The Map
//
//  Created by Hung Truong on 3/30/24.
//

import Foundation

struct NetworkingUtility {

    static func performNetworkRequest<T: Decodable>(url: URL, httpMethod: String = "GET", body: Data? = nil, rangeOffset: Int? = nil) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            throw NSError(domain: "NetworkingError", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed with status code: \(statusCode)"])
        }
        
        let newData = rangeOffset != nil ? data.subdata(in: rangeOffset!..<data.count) : data
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: newData)
    }
}
