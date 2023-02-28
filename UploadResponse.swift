//
//  UploadResponse.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 28/02/2023.
//

import Foundation

// MARK: - UploadResponse
struct UploadResponse: Codable {
    let data: DataObject?
    let responseText: String
    let responseCode: Int
}

// MARK: - DataClass
struct DataObject: Codable {
    let file_url: String
}
