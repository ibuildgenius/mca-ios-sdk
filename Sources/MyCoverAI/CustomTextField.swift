//
//  CustomTextField.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 01/02/2023.
//

import SwiftUI

struct CustomTextField: View {
    let label: String
    let inputType: UIKeyboardType
    let hint: String
    let disabled: Bool
    @State var text: String = ""
    
    var onTap: (() -> Void)? = nil
    var onChange: ((String) -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label).font(spaceGroteskRegularSM).padding(.bottom,2)
            
            if(onTap == nil) {
                TextField(hint, text: $text)
                    .font(spaceGroteskRegular)
                    .padding(.all, 12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(searchBorderColor, lineWidth: 1)
                    )
                    .background(colorGrey)
                    .keyboardType(inputType)
                    .disabled(disabled)
                
            } else {
            
            
            TextField(hint, text: $text)
                .font(spaceGroteskRegular)
                .padding(.all, 12)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(searchBorderColor, lineWidth: 1)
                )
                .background(colorGrey)
                .onChange(of: text, perform: onChange ?? {val in })
                .keyboardType(inputType)
                .disabled(disabled)
         
                .onTapGesture { onTap!() }
            }
            
        }
    }
}


