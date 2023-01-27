//
//  TabDataModel.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 27/01/2023.
//

import Foundation
import SwiftUI

struct TabDataModel {
    let tabTitles: [String]
    let spacingBetweenTabs: CGFloat
    let paddingLeftRight: CGFloat
    let selectedTabDataModel: SelectedTabDataModel
    let unselectedTabDataModel: UnSelectedTabDataModel
}

struct SelectedTabDataModel: TagViewProtocol {
    var textColor: Color
    var backgroundColor: Color
    var borderColor: Color
    var borderWidth: CFloat
    var cornerRadius: CFloat
}

struct UnSelectedTabDataModel: TagViewProtocol {
    var textColor: Color
    var backgroundColor: Color
    var borderColor: Color
    var borderWidth: CFloat
    var cornerRadius: CFloat
}


protocol TagViewProtocol {
    var textColor: Color { get }
    var backgroundColor: Color { get }
    var borderColor: Color { get }
    var borderWidth: CFloat { get }
    var cornerRadius: CFloat { get }
}
