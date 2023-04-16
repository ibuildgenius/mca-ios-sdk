//
//  TransactionResponse.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 21/02/2023.
//

import Foundation
import AnyCodable

struct TransactionResponse: Decodable {
    let responseText: String
    let responseCode: Int
    let data: TransactionData?
}

struct TransactionData: Decodable {
    let reference: String
    let id: Int
    let amount: Int
}
