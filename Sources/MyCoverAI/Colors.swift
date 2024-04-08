//
//  Colors.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 27/01/2023.
//

import SwiftUI


let colorPrimary = Color(UIColor(named: "mcgTeal", in: .module, compatibleWith: nil)!)

let colorGrey = Color(UIColor(named: "colorGray", in: .module, compatibleWith: nil)!)

let filterTextColor = Color(UIColor(named: "filterTextColor", in: .module, compatibleWith: nil)!)

let searchBorderColor = Color(UIColor(named: "searchBorderColor", in: .module, compatibleWith: nil)!)

let blackText = Color(UIColor(named: "blackText", in: .module, compatibleWith: nil)!)

let lightGrey = Color(UIColor(named: "lightGrey", in: .module, compatibleWith: nil)!)

let bgWhite = Color(UIColor(named: "bgWhite", in: .module, compatibleWith: nil)!)

let shadowColor = Color(UIColor(named: "shadowColor", in: .module, compatibleWith: nil)!)


let colorPrimaryTrans = Color(UIColor(named: "mcgTealTrans", in: .module, compatibleWith: nil)!
)


let SpaceGroteskMedium: Font = Font.custom("SpaceGrotesk-Medium", size: 14)

let SpaceGroteskMedium25: Font = Font.custom("SpaceGrotesk-Medium", size: 25)
let SpaceGroteskBold20: Font = Font.custom("SpaceGrotesk-Bold", size: 20)
let SpaceGroteskBold: Font = Font.custom("SpaceGrotesk-Bold", size: 16)

let SpaceGroteskBold25: Font = Font.custom("SpaceGrotesk-Bold", size: 25)

let SpaceGroteskBold14: Font = Font.custom("SpaceGrotesk-Bold", size: 14)

let SpaceGroteskBold18: Font = Font.custom("SpaceGrotesk-Bold", size: 18)
let SpaceGroteskBold16: Font = Font.custom("SpaceGrotesk-Bold", size: 16)

let spaceGroteskRegular: Font = Font.custom("SpaceGrotesk-Regular", size: 14)

let spaceGroteskRegular13: Font = Font.custom("SpaceGrotesk-Regular", size: 13)

let spaceGroteskRegularSM: Font = Font.custom("SpaceGrotesk-Regular", size: 12)


//let metropolisMedium: Font = Font.custom("Metropolis-Medium", size: 14)
//
//let metropolisMedium25: Font = Font.custom("Metropolis-Medium", size: 25)
//
//let metropolisBold: Font = Font.custom("Metropolis-Bold", size: 16)
//
//let metropolisBold25: Font = Font.custom("Metropolis-Bold", size: 25)
//
//let metropolisBold14: Font = Font.custom("Metropolis-Bold", size: 14)
//
//let metropolisBold18: Font = Font.custom("Metropolis-Bold", size: 18)
//let metropolisBold16: Font = Font.custom("Metropolis-Bold", size: 16)
//
//let metropolisRegular: Font = Font.custom("Metropolis-Regular", size: 14)
//
//let metropolisRegular13: Font = Font.custom("Metropolis-Regular", size: 13)
//
//let metropolisRegularSM: Font = Font.custom("Metropolis-Regular", size: 12)

public func SCImage(name: String) -> UIImage? {
    UIImage(named: name, in: .module, compatibleWith: nil)
}

public func SCIcon(sysName: String) -> UIImage? {
    UIImage(systemName: sysName)
}
