//
//  Credential.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 24/01/2023.
//

import Foundation


struct Credential {
    static var APIKEY: String                 = ""
    static var reference: String              = ""
    static var paymentOption: String          = ""
    static var formData: [String: Any]        = [:]
    static var onSuccess: (() -> Void)?
}

//let APIKEY = "MCAPUBK_TEST|48c01008-5f01-4705-b63f-e71ef5fc974f"
