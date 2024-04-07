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
                Image(uiImage: SCImage(name: image)!)
                VStack(alignment:.leading) {
                    Text(title).font(SpaceGroteskBold18).padding(.bottom, 1)
                    Text(description).font(spaceGroteskRegular13).foregroundColor(blackText.opacity(0.8))
                }.padding(.horizontal, 12).frame(maxWidth: .infinity, alignment: .leading)
            }.padding(15)
         
        } .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(isSelected ? colorPrimary : lightGrey.opacity(0.7), lineWidth: isSelected ? 2 : 0.8)
            )
//        .shadow(radius: 1)
        
       
        .padding(.top, 15)
    }
}
