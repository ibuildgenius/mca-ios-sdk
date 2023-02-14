//
//  PaymentDetailsScreen.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 03/02/2023.
//

import SwiftUI

struct PaymentDetailsScreen: View {
    let product: ProductDetail
    let fields: [String: String]
    
    
    var body: some View {
        PageTemplate(onBackPressed: {}, mContent: {
            return AnyView(VStack {
                Text("\(product.name) x \(fields.description)")
            })
            
        }).navigationBarHidden(true)
    }
}
