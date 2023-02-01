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
    @State var text: String
    let onTap: () -> Void
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label).font(font12)
            TextField(hint, text: $text)
                .font(font14)
                .padding(.all, 7)
                .background(Color.gray.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray, lineWidth: 1)
                )
                .keyboardType(inputType)
                .disabled(disabled)
                .onTapGesture {
                    onTap()
                }
        }
    }
}


