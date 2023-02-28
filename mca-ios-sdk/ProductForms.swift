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
    let transactionResponse: TransactionResponse?
    let data: [String: Any]?
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var name: String = ""
    @State private var fields: [String: Any] = [:]
    @State private var selectItems: [String:[AnyDecodable]] = [:]
    @State private var showPayment = false
    @State private var purchaseComplete = false
    @State private var isBusy = false;
    @State private var currentFormSetIndex = 0
    @State private var date: Date? = Date()
    @State private var selectText = ""
    @State private var files: [String: URL] = [:]
    
    @State private var completeText = ""
    @State private var buttonText = "Continue"
    @State private var done = false
    
    
    func getSelectField(form: FormFieldElement) async {
        if(form.dataURL != nil ) {
            let res = await networkService.getSelectFieldOptions(url: form.dataURL!)
            
            if(res != nil && res?.responseCode == 1) {
                selectItems[form.name] = res?.data
                
                print(" \(selectItems) ")
            }
        }
    }
    
    
    
    func uploadFiles() async -> [String: Any] {
        var updatedFields = fields
        if(!files.isEmpty) {
            for item in files.keys {
                let result = await networkService.uploadFile(file: files[item]!)
                if(result != nil && result?.responseCode == 1) {
                    updatedFields[item] = result!.data!.file_url
                }
            }
        }
        return updatedFields
    }
    
    func format(payload: [String: Any]) -> [String: Any] {
        
        var newPayload: [String: Any] = payload
        
        newPayload["product_id"] = product.id
        
        if(data != nil) {
            newPayload.merge(dict: data!)
        }
        
        
        let paymentPayload: [String: Any] = ["payload": newPayload, "reference": transactionResponse!.data!.reference]
        
        print("Formatted Response \(paymentPayload)")
        
        
        return paymentPayload
    }
    
    
    func completePurchase() async {
        isBusy = true
        let payload = await uploadFiles()
        
        let result = await networkService.completePurchase(payload: format(payload: payload))
        isBusy = false
        
        let responseCode = (result!["responseCode"]!).value as! Int
        
        
        
        if(result != nil && responseCode == 1) {
            let text = (result!["responseText"]!).value as! String
            
            completeText = text.capitalized
            buttonText = "Done"
            purchaseComplete = true
            
        }
    }
    
    var body: some View {
        
        if(done) {
            ProductListView()
        } else {
            ZStack {
                VStack {
                    if (!showPayment) {
                        PageTemplate(onBackPressed: {
                            if(currentFormSetIndex > 0) {
                                currentFormSetIndex -= 1
                            }else {
                                presentationMode.wrappedValue.dismiss()
                            }
                            
                        }, mContent: {
                            
                            let formSet = transactionResponse == nil ? product.formFields.showFirstFields().chunked(into: 3) : product.formFields.afterPaymentFields().chunked(into: 3)
                            
                            
                            return AnyView(VStack {
                                
                                if(purchaseComplete) {
                                    VStack {
                                        LottieView(lottieFile: "check", loopMode: .playOnce)
                                            .frame(width: 180, height: 180).padding(13)
                                        
                                        Text(completeText).font(metropolisBold18)
                                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                } else {
                                    
                                    
                                    VStack {
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
                                                        FilePicker(types: [.data], allowMultiple: false) { urls in
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
                                    }
                                }
                                
                                
                                
                                
                                Button(buttonText) {
                                    if (currentFormSetIndex < formSet.count  - 1) {
                                        currentFormSetIndex += 1
                                    } else {
                                        if(transactionResponse != nil) {
                                            if(purchaseComplete) {
                                                done = true
                                            } else {
                                                Task {
                                                    await completePurchase()
                                                }
                                            }
                                            
                                        } else {
                                            fields["product_id"] = product.id
                                            showPayment = true
                                        }
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
                    }
                    else {
                        PaymentDetailsScreen(onBackPressed: {
                            showPayment.toggle()
                        },  product: product, fields: fields, files: files)
                    }
                }
                
                if(isBusy) {
                    LoadingOverlay(loadingText: "Please wait...")
                }
            }
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

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
