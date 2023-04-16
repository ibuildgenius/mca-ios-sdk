//
//  Bank.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 18/02/2023.
//

import Foundation

// MARK: - ProductPurchaseResponse
struct BankResponse: Decodable {
    let responseCode: Int
    let responseText: String
    let data: BankData
}

// MARK: - DataClass
struct BankData: Decodable {
    let banks: [Bank]
}

// MARK: - Bank
struct Bank: Decodable, Identifiable {
    let id: Int
    let name, slug, code, longcode: String
    let gateway: String?
    let pay_with_bank: Bool
    let active: Bool?
    let country: String
    let currency: String
    let type: String
    let isDeleted: Bool?
    let createdAt: String?
    let updatedAt: String
}

extension Bank {
    func isValid() -> Bool {
        let supportedCodes = [044, 050, 070, 011, 214, 058, 030, 082, 221, 232, 032, 033, 215, 090110, 035, 057]
        
        return supportedCodes.contains(Int(self.code) ?? 000000000)
    }
}

