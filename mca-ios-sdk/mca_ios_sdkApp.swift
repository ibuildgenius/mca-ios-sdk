//
//  mca_ios_sdkApp.swift
//  mca-ios-sdk
//

import SwiftUI
import SwiftUI_NotificationBanner

@main
struct mca_ios_sdkApp: App {
    
    
    @StateObject var products = Sample()
    @StateObject var notificationHandler = DYNotificationHandler()
    
   
    var body: some Scene {
        WindowGroup {
        
            NavigationView {
                ProductListView()
            }.navigationBarHidden(true)
                .environmentObject(notificationHandler)
            

          
        }
    }
}
