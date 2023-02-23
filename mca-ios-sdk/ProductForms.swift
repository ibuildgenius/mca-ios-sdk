//
//  ProductForms.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 26/01/2023.
//

import SwiftUI
import FilePicker
import AnyCodable

struct ProductForms: View {
    let product: ProductDetail
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var name: String = ""
    @State private var fields: [String: Any] = [:]
    @State private var selectItems: [String:[AnyDecodable]] = [:]
    @State private var showPayment = false
    @State private var currentFormSetIndex = 0
    @State private var date: Date? = Date()
    @State private var selectText = ""
    @State private var files: [String: URL] = [:]
    
    
    func getSelectField(form: FormFieldElement) async {
        if(form.dataURL != nil ) {
            let res = await networkService.getSelectFieldOptions(url: form.dataURL!)
            
            if(res != nil && res?.responseCode == 1) {
                selectItems[form.name] = res?.data
                
                print(" \(selectItems) ")
            }
        }
    }
    
    var body: some View {
        
        if (!showPayment) {
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
                        Image(systemName: "info.circle.fill").resizable().frame(width: 15, height: 15).foregroundColor(colorPrimary)
                        
                        Text("Enter details as it appears on legal documents")
                            .font(metropolisRegular13)
                            .padding(.leading, 5)
                    }.padding(0)
                    
                    HStack {
                        VStack{}.frame(maxWidth: .infinity)
                        Text("Underwritten by: \(product.productDetailPrefix.capitalized)").font(metropolisRegularSM)
                    }
                    
                    
                    VStack {
                        let forms = formSet[currentFormSetIndex]
                        ForEach(forms) {form in
                            
                            VStack(alignment: .leading) {
                                
                                if(form.inputType == InputType.date) {

                                   Text(form.label).font(metropolisRegularSM)

                                    DatePickerTextField(placeholder: "", date: $date, onDateChange: {
                                        value in

                                        fields[form.name] = value

                                        print(value)

                                    }).padding(.all, 7)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(.gray, lineWidth: 1)
                                        )
                                        .background(Color.gray.opacity(0.1))
                                    
                                    
                            
                                    
                                } else if(form.inputType == InputType.file) {
                                    FilePicker(types: [.plainText], allowMultiple: false) { urls in
                                        print("selected \(urls[0]) files")
                                        if (urls[0] != nil) {
                                            files[form.name] = urls[0]
                                        }
                                    } label: {
                                        CustomTextField(
                                            label: form.label,
                                            inputType: resolveKeyboardType(inputType: form.inputType),
                                            hint: form.description,
                                            disabled: true,
                                            text: name
                                        )
                                    }
                                }
                                
                                else {
                                    
                                    if(form.formField.name!.lowercased().contains("select")) {
                                        if(selectItems[form.name] != nil) {
                                        
                                            Menu(content: {
                                                ForEach(selectItems[form.name]!, id: \.self) {
                                                    item in
                                                    Button("\(item.description)") {
                                                        fields[form.name] = item.value
                                                    }
                                                }
                                            }, label: {
                                                CustomTextField(
                                                    label: "\(form.label)",
                                                    inputType: resolveKeyboardType(inputType: form.inputType),
                                                    hint: "\(fields[form.name] ?? form.description)",
                                                    disabled: true,
                                                    text: "\(fields[form.name] ?? "")",
                                                    onTap: {}
                                                )
                                            })
                                         
                                        } else {
                                     
                                        }
                                    } else {
                                    
                                        CustomTextField(
                                            label: form.label,
                                            inputType: resolveKeyboardType(inputType: form.inputType),
                                            hint: form.description,
                                            disabled: false,
                                            text: "\(fields[form.name] as? String ?? "") ",
                                            onTap: {
                                                print("\(form.label) is \(fields[form.label] ?? "")")
                                            },
                                            onChange: {value in
                                                
                                                if(form.dataType == DataType.number) {
                                                    fields[form.name] = Int(value.trimmingCharacters(in: .whitespacesAndNewlines))
                                                } else {
                                                    fields[form.name] = value.trimmingCharacters(in: .whitespacesAndNewlines)
                                                }
                                                 
                                                print(value.description)
                                                print("form field value \(form.dataType) \(fields[form.name] ?? "")")
                                            }
                                        )
                                    }
                                }
                                
                                
                            }.padding(.vertical, 4).task {
                                let _: () = await getSelectField(form: form)
                            }
                            
                        }
                    }.padding(.top,15)
                    
                    VStack {}.frame(maxHeight: .infinity)
                    
                    Button("Continue") {
                        if (currentFormSetIndex < formSet.count  - 1) {
                            currentFormSetIndex += 1
                        } else {
                            fields["product_id"] = product.id
                            showPayment = true
                        }
                        print("index \(currentFormSetIndex) count \(formSet.count) \(formSet.indices)")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                    .background(colorPrimary)
                    .clipShape(Capsule())
                    
                }
                    .padding(.horizontal, 12)
                )
            }).navigationBarHidden(true)
        } else {
            PaymentDetailsScreen(onBackPressed: {
                showPayment.toggle()
            },  product: product, fields: fields, files: files)
        }
        
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


extension Binding {
    func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}
