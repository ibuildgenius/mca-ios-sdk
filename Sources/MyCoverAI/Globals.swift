//
//  Globals.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 23/02/2023.
//

import Foundation

struct Globals {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
}
