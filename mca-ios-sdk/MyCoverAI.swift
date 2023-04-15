//
//  MyCoverAI.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 09/04/2023.
//

import Foundation
import SwiftUI
import SwiftUI_NotificationBanner

struct MyCoverAISDK: View {
    let apiKey: String
 
    var body: some View {
          
                ProductListView().onAppear{
                    Credential.APIKEY = apiKey
                }
          
            
    }

}
