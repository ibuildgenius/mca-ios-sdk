//
//  mca_ios_sdkApp.swift
//  mca-ios-sdk
//

import SwiftUI
import SwiftUI_NotificationBanner

@main
struct mca_ios_sdkApp: App {
       @StateObject var notificationHandler = DYNotificationHandler()
    
   
    var body: some Scene {
        WindowGroup {
        
            NavigationView {
                MyCoverAISDK(apiKey: "MCAPUBK_TEST|48c01008-5f01-4705-b63f-e71ef5fc974f")
            }.navigationBarHidden(true)
                .environmentObject(notificationHandler)
            

          
        }
    }
}
