//
//  MyCoverAI.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 09/04/2023.
//

import Foundation
import SwiftUI

public struct Person {
    public var firstName: String?
    public var phone: String?
    public var lastName: String?
    public var email: String?
    
    public init(firstName: String?, lastName: String?, email: String?, phone: String?) {
        self.firstName = firstName
        self.lastName  = lastName
        self.email     = email
        self.phone     = phone
    }
}

public struct MyCoverSDK: View {
    let apiKey : String
    let paymentOption: String?
    let reference: String?
    let form   : Person?
    let onSuccess: (() -> Void)
    
    
    public init(apiKey: String, form: Person? = nil, paymentOption: String? = nil, reference: String? = nil,  onSuccess: @escaping (() -> Void)) {
        self.apiKey = apiKey
        self.form = form
        self.paymentOption = paymentOption
        self.reference = reference
        self.onSuccess = onSuccess
        
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
        //        let fonts = ["Metropolis-Bold","Metropolis-Medium","Metropolis-Regular"]
        let fonts = ["SpaceGrotesk-Bold","SpaceGrotesk-Medium","SpaceGrotesk-Regular"]
        
        fonts.forEach { font in
            registerFont(bundle: .module, fontName: font, fontExtention: ".ttf")
        }
    }
    
    
    public var body: some View {
        
        ProductListView().onAppear{
            Credential.APIKEY = apiKey
            Credential.paymentOption  = paymentOption ?? "gateway"
            Credential.reference      = reference     ?? ""
            Credential.onSuccess      = onSuccess
            let newPerson = form
            let phone     = newPerson?.phone   ?? ""
            let firstName = newPerson?.phone   ?? ""
            let lastName  = newPerson?.lastName ?? ""
            let email     = newPerson?.email    ?? ""
            
            if Credential.formData["first_name"] == nil {
                Credential.formData["first_name"] = "firstName"
            }
            if Credential.formData["last_name"] == nil {
                Credential.formData["last_name"] = lastName
            }
            if Credential.formData["email"] == nil {
                Credential.formData["email"] = email
            }
            if Credential.formData["phone"] == nil {
                Credential.formData["phone"] = phone
            }
            
            
        }
        
    }
}
