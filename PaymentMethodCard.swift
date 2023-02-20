//
//  PaymentMethodCard.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 18/02/2023.
//

import SwiftUI

struct PaymentMethodCard: View {
    let title: String
    let description: String
    let isSelected: Bool
    let image: String
    
    var body: some View {
        
        HStack {
            HStack{
                Image(image)
                VStack(alignment:.leading) {
                    Text(title).font(metropolisBold18)
                    Text(description).padding(.vertical, 6).font(metropolisRegular13).foregroundColor(Color.gray)
                }.padding(.horizontal, 12).frame(maxWidth: .infinity, alignment: .leading)
            }.padding(8)
         
        } .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(isSelected ? colorPrimary : colorGrey, lineWidth: isSelected ? 2 : 0.8)
            )
        .shadow(radius: 1)
        
       
        .padding(.top, 15)
    }
}
