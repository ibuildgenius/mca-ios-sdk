//
//  mca_ios_sdkApp.swift
//  mca-ios-sdk
//

import SwiftUI

@main
struct mca_ios_sdkApp: App {
    
    
    @StateObject var products = Sample()
    
    var body: some Scene {
        WindowGroup {
        
            NavigationView {
                ProductListView()
            }.navigationBarHidden(true)
            

          
        }
    }
}
