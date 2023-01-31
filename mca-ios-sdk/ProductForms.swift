//
//  ProductForms.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 26/01/2023.
//

import SwiftUI

struct ProductForms: View {
    let product: ProductDetail
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var name: String = ""
    
   var font12 = Font.custom("", size: 12)
    
    var body: some View {
        PageTemplate(onBackPressed: { presentationMode.wrappedValue.dismiss()}, mContent: {
            
            let forms = product.formFields.filter { $0.showFirst }
            
            return AnyView(VStack {
                
                HStack {
                    Image(systemName: "info.circle.fill").foregroundColor(pColor)
                    Text("Enter details as it appears on legal documents")
                        .font(Font.custom("", size: 14))
                        .padding(.leading, 5)
                }
                
                HStack {
                    VStack{}.frame(maxWidth: .infinity)
                    Text("Underwritten by: \(product.productDetailPrefix.capitalized)").font(font12)
                    
                }
                
                
                VStack {
                    ForEach(forms.indices) {i in
                        let form = forms[i]
                        VStack(alignment: .leading) {
                            Text(form.label).font(font12)
                            TextField(form.description, text: $name)
                                .padding(.all, 5)
                                .background(Color.gray.opacity(0.2))
                                
                        }.padding(.vertical, 4)
                        
                    }
                }.frame(maxHeight: .infinity)
                
            
            }.padding(.horizontal, 12)
            )
        }
        )
        .navigationBarHidden(true)
    }
}
