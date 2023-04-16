//
//  MyCoverAI.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 09/04/2023.
//

import Foundation
import SwiftUI

public struct MyCoverSDK: View {
    let apiKey: String
    
    public init(apiKey: String) {
        self.apiKey = apiKey
        registerFonts()
    }
    
    
    fileprivate func registerFont(bundle: Bundle, fontName: String, fontExtention: String) {
        guard let fontUrl =  bundle.url(forResource: fontName, withExtension: fontExtention),
              let fontDataProvider = CGDataProvider(url: fontUrl as CFURL),
              let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from filename: \(fontName) with extension: \(fontExtention)")
        }
        
        var error: Unmanaged<CFError>?
        
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
    
    
    private func registerFonts() {
        let fonts = ["Metropolis-Bold","Metropolis-Medium","Metropolis-Regular"]
        
        fonts.forEach { font in
            registerFont(bundle: .module, fontName: font, fontExtention: ".otf")
        }
    }
    
 
    public var body: some View {
          
                ProductListView().onAppear{
                    Credential.APIKEY = apiKey
                }
          
            
    }

}
