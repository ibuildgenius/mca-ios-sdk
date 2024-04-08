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

func getLogo(prefix: String) -> String {
    let lowercasePrefix = prefix.lowercased()
    
    if lowercasePrefix.contains("mcg") || lowercasePrefix.contains("mycovergenius") {
        return "mcg"
    } else if lowercasePrefix.contains("aiico") {
        return "aiico"
    } else if lowercasePrefix.contains("sti") {
        return "sti"
    } else if lowercasePrefix.contains("flexicare") {
        return "flexicare"
    }
    else if lowercasePrefix.contains("leadway") {
        return "leadway"
    }
    else {
        return "none"
    }
}
