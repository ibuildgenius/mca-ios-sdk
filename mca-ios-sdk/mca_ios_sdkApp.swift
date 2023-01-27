//
//  mca_ios_sdkApp.swift
//  mca-ios-sdk
//

import SwiftUI

@main
struct mca_ios_sdkApp: App {
    
    
    @StateObject var products = Sample()
    
    var body: some Scene {
        let networkService = NetworkService(baseURLString: "https://staging.api.mycover.ai")

        WindowGroup {
        
            NavigationView {
                ProductListView().environmentObject(products)
            }.navigationBarHidden(true)
            

          
        }
    }
}
