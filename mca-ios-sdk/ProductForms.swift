//
//  ProductForms.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 26/01/2023.
//

import SwiftUI
import FilePicker

struct ProductForms: View {
    let product: ProductDetail
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var name: String = ""
    
    @State private var currentFormSetIndex = 0
    @State private var date = Date()
    //@State private var fields: List<KeyValuePairs> = [][]
    
    
    var body: some View {
        PageTemplate(onBackPressed: {
            if(currentFormSetIndex > 0) {
                currentFormSetIndex -= 1
            }else {
            presentationMode.wrappedValue.dismiss()
            }
            
        }, mContent: {
            
            let formSet = product.formFields.sorted{$0.position < $1.position} .filter { $0.showFirst }.chunked(into: 3)
            
            return AnyView(VStack {
                
                HStack {
                    Image(systemName: "info.circle.fill").foregroundColor(pColor)
                    Text("Enter details as it appears on legal documents")
                        .font(font14)
                        .padding(.leading, 5)
                }
                
                HStack {
                    VStack{}.frame(maxWidth: .infinity)
                    Text("Underwritten by: \(product.productDetailPrefix.capitalized)").font(font12)
                    
                }
                
                
                VStack {
                    let forms = formSet[currentFormSetIndex]
                    
                    ForEach(forms) {form in
                        
                        VStack(alignment: .leading) {
                            
                            
                            if(form.inputType == InputType.date) {
                                
                             
                             
                                        CustomTextField(
                                            label: form.label,
                                            inputType: resolveKeyboardType(inputType: form.inputType),
                                            hint: form.description,
                                            disabled: true,
                                            text: date.formatted(date: .long, time: .omitted),
                                            onTap: {}
                                        )
                                    
                             
        
                            } else if(form.inputType == InputType.file) {
                                // Use custom content for the button label
                                           FilePicker(types: [.plainText], allowMultiple: false) { urls in
                                               print("selected \(urls.count) files")
                                           } label: {
                                               CustomTextField(
                                                   label: form.label,
                                                   inputType: resolveKeyboardType(inputType: form.inputType),
                                                   hint: form.description,
                                                   disabled: true,
                                                   text: name,
                                                   onTap: {}
                                               )
                                           }
                            }
                            
                            else {
                                CustomTextField(
                                    label: form.label,
                                    inputType: resolveKeyboardType(inputType: form.inputType),
                                    hint: form.description,
                                    disabled: false,
                                    text: name,
                                    onTap: {}
                                )
                            }
                            
                           
                        }.padding(.vertical, 4)
                        
                    }
                }.frame(maxHeight: .infinity)
                
                Button("Continue") {
                    if (currentFormSetIndex < formSet.count  - 1) {
                        currentFormSetIndex += 1
                    }
                    print("index \(currentFormSetIndex) count \(formSet.count) \(formSet.indices)")
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                    .background(pColor)
                    .clipShape(Capsule())
                   
                
            
            }.padding(.horizontal, 12)
            )
        }
        )
        .navigationBarHidden(true)
    }
}


extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}


func resolveKeyboardType(inputType: InputType) -> UIKeyboardType {
    switch (inputType) {
    case InputType.email: return UIKeyboardType.emailAddress
    case InputType.number: return UIKeyboardType.numberPad
    case InputType.phone: return UIKeyboardType.phonePad
    default: return UIKeyboardType.default
        
    }
}



struct NoHitTesting: ViewModifier {
    func body(content: Content) -> some View {
        SwiftUIWrapper { content }.allowsHitTesting(false)
    }
}

extension View {
    func userInteractionDisabled() -> some View {
        self.modifier(NoHitTesting())
    }
}

struct SwiftUIWrapper<T: View>: UIViewControllerRepresentable {
    let content: () -> T
    func makeUIViewController(context: Context) -> UIHostingController<T> {
        UIHostingController(rootView: content())
    }
    func updateUIViewController(_ uiViewController: UIHostingController<T>, context: Context) {}
}
