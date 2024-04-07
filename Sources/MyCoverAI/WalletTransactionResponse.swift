//
//  File.swift
//  
//
//  Created by Fuhad on 07/04/2024.
//

import Foundation
import AnyCodable


struct WalletTransactionResponse: Codable {
    let responseCode: Int
    let data: WalletTransactionData?
    let responseText: String
}

struct WalletTransactionData: Codable {
    let amount: Int
    let reference: String
}
