//
//  Colors.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 27/01/2023.
//

import SwiftUI


let colorPrimary = Color(UIColor(named: "mcgTeal", in: .module, compatibleWith: nil)!)

let colorGrey = Color(UIColor(named: "colorGray", in: .module, compatibleWith: nil)!)


let colorPrimaryTrans = Color(UIColor(named: "mcgTealTrans", in: .module, compatibleWith: nil)!
)


let metropolisMedium: Font = Font.custom("Metropolis-Medium", size: 14)

let metropolisMedium25: Font = Font.custom("Metropolis-Medium", size: 25)

let metropolisBold: Font = Font.custom("Metropolis-Bold", size: 16)

let metropolisBold25: Font = Font.custom("Metropolis-Bold", size: 25)

let metropolisBold14: Font = Font.custom("Metropolis-Bold", size: 14)

let metropolisBold18: Font = Font.custom("Metropolis-Bold", size: 18)
let metropolisBold16: Font = Font.custom("Metropolis-Bold", size: 16)

let metropolisRegular: Font = Font.custom("Metropolis-Regular", size: 14)

let metropolisRegular13: Font = Font.custom("Metropolis-Regular", size: 13)

let metropolisRegularSM: Font = Font.custom("Metropolis-Regular", size: 12)

public func SCImage(name: String) -> UIImage? {
    UIImage(named: name, in: .module, compatibleWith: nil)
}

public func SCIcon(sysName: String) -> UIImage? {
    UIImage(systemName: sysName)
}
