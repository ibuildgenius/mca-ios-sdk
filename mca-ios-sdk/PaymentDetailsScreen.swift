//
//  PaymentDetailsScreen.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 03/02/2023.
//

import SwiftUI

struct PaymentDetailsScreen: View {
    let onBackPressed: (() -> Void)
    let product: ProductDetail
    let fields: [String: String]
    
    
    var body: some View {
        PageTemplate(onBackPressed: onBackPressed, mContent: {
            return AnyView(VStack {
                VStack(alignment: .leading) {
                    
                    VStack(alignment: .leading) {
                        
                        VStack(alignment: .trailing) {
                            Text("ysenruf@gmail.com").font(metropolisRegular).foregroundColor(Color.gray)
                            HStack{Text("Pay").font(metropolisRegular).foregroundColor(Color.gray); Text("N\(product.price)")}.padding(0).font(metropolisBold14).foregroundColor(colorPrimary)
                        }.frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(12)
                            .background(colorGrey)
                            .padding(.vertical, 15)
            
                        
                        
                        Text("Select Payment method").font(metropolisBold25)
                        
                        Text("Choose an option to proceed").font(metropolisRegular13).padding(.vertical, 2).foregroundColor(Color.gray)
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    
                
                    Button("Continue") {
                     
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                        .background(colorPrimary)
                        .clipShape(Capsule())
                    
                    
                }.padding(.horizontal, 12)
            })
            
        }).navigationBarHidden(true)
    }
}
