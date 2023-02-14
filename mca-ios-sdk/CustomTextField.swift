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
            Text(label).font(metropolisRegularSM)
            
            if(onTap == nil) {
                TextField(hint, text: $text)
                    .font(metropolisRegular)
                    .padding(.all, 7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray, lineWidth: 1)
                    )
                    .background(Color.gray.opacity(0.2))
                    .keyboardType(inputType)
                    .disabled(disabled)
                
            } else {
            
            
            TextField(hint, text: $text)
                .font(metropolisRegular)
                .padding(.all, 7)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray, lineWidth: 1)
                )
                .background(Color.gray.opacity(0.2))
                .onChange(of: text, perform: onChange ?? {val in })
                .keyboardType(inputType)
                .disabled(disabled)
         
                .onTapGesture { onTap!() }
            }
            
        }
    }
}


