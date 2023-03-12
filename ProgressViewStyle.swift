//
//  ProgressViewStyle.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 01/03/2023.
//

import Foundation
import SwiftUI


struct WithBackgroundProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .padding(8)
            .tint(colorPrimary)
    }
}
 
