//
//  CustomTextField.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 01/02/2023.
//

import SwiftUI

struct SearchTextField: View {
    let hint: String
    let disabled: Bool
    @State var text: String = ""
    var onTap: (() -> Void)? = nil
    var onChange: ((String) -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack{
                Image(uiImage: SCIcon(sysName: "magnifyingglass")!)
                    .resizable().frame(width: 15, height: 15)
                    .foregroundColor(searchBorderColor).padding(.leading, 15)
                TextField(hint, text: $text)
                    .font(spaceGroteskRegular)
                    
                    .padding(.all, 12)
                    .onChange(of: text, perform: onChange ?? {val in })
             }
                .background(Color.white)
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(searchBorderColor, lineWidth: 1)
                )
            
            
        }
    }
}


