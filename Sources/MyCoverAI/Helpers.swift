//
//  Helpers.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 07/03/2023.
//

import Foundation


func formatNumbers(number: Double) -> String {
   
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    
    return numberFormatter.string(from: NSNumber(value:number)) ?? String(number)
}
