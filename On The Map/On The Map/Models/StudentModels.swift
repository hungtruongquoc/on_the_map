//
//  StudentModels.swift
//  On The Map
//
//  Created by Hung Truong on 3/30/24.
//

import Foundation

struct StudentInformation: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}

struct StudentList: Codable {
    let results: [StudentInformation]
}

struct StudentLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}

struct StudentLocationResponse: Codable {
    let createdAt: String
    let objectId: String
}
