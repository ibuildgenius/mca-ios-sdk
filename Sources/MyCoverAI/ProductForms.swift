//
//  ProductForms.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 26/01/2023.
//

import SwiftUI
import FilePicker
import PhotosUI
import AnyCodable

struct ProductForms: View {
    let product: ProductDetail
    let transactionResponse: TransactionResponse?
    let data: [String: Any]?
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var name: String = ""
    @State private var fields: [String: Any] = Credential.formData
    @State private var selectItems: [String:[AnyDecodable]] = [:]
    @State private var showPayment = false
    @State private var purchaseComplete = false
    @State private var isBusy = false;
    @State private var currentFormSetIndex = 0
    @State private var date: Date? = Date()
    @State private var selectText = ""
    @State private var files: [String: URL] = [:]
    @State private var formName = ""
    @State private var initializedTransactionResponse: TransactionResponse?
    @State private var responseText = ""
    @State private var responseTitle = ""
    @State private var showAlert = false
    
    
    @State private var completeText = ""
    @State private var buttonText = "Continue"
    @State private var done = false
    
    @State var selectProfileImage = false
    @State var openCameraRoll     = false
    @State var selectedImage      = UIImage()
    @State var imageUrl: URL?
    
    // Add an initializer to set initializedTransactionResponse
    init(product: ProductDetail, transactionResponse: TransactionResponse?, data: [String: Any]?) {
        self.product = product
        self.transactionResponse = transactionResponse
        self.data = data
        // Set initializedTransactionResponse after self is fully initialized
        _initializedTransactionResponse = State(initialValue: transactionResponse)
    }
    
    
    
    
    func getSelectField(form: FormFieldElement) async {
        if(form.data_url != nil ) {
            let res = await networkService.getSelectFieldOptions(url: form.data_url!)
            
            if(res != nil && res?.responseCode == 1) {
                
                var options: [AnyDecodable] = []
                
                res?.data.forEach {item in
                    
                    if(item.value is [String: Any]) {
                        
                        let x = (item.value as! [String: Any])["name"]
                        
                        options.append(AnyDecodable(x))
                    } else {
                        options.append(AnyDecodable(item.value))
                        
                    }
                    
                }
                
                selectItems[form.name] = options
                
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
        
        updatedFields["is_full_year"] = true
        return updatedFields
    }
    
    func format(payload: [String: Any]) -> [String: Any] {
        
        var newPayload: [String: Any] = payload
        
        newPayload["product_id"] = product.id
        
        if(data != nil) {
            newPayload.merge(dict: data!)
        }
        
        
        let paymentPayload: [String: Any] = ["payload": newPayload, "reference": initializedTransactionResponse!.data!.reference]
        
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
        
        else{
            let errorText = (result!["responseText"]!).value as! String
            
            responseText = errorText
            
            showAlert = true
            
            
        }
    }
    
    func initiateWalletPurchase() async {
        isBusy = true
        
        let payload = await uploadFiles()
        
        let result = await networkService.initiateWalletPurchase(formData: payload)
        isBusy = false
        let responseCode = result?.responseCode
        if(result != nil && responseCode == 1) {
            currentFormSetIndex = 0
            initializedTransactionResponse =  TransactionResponse(
                responseText: result!.responseText,
                responseCode: result!.responseCode,
                data: TransactionData(
                    reference: result!.data!.reference,
                    id: nil,
                    amount: result!.data!.amount))
        }
        else{
            let errorText = result?.responseText
            responseText = errorText ?? ""
            showAlert = true
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
                                if (initializedTransactionResponse == nil) {
                                    presentationMode.wrappedValue.dismiss() }
                            }
                            
                        }, mContent: {
                            
                            let formSet = initializedTransactionResponse == nil ? product.form_fields.showFirstFields().chunked(into: 3) : product.form_fields.afterPaymentFields().chunked(into: 3)
                            
                            
                            return AnyView(VStack {
                                
                                if(purchaseComplete) {
                                    VStack {
                                        LottieView(lottieFile: "check", loopMode: .playOnce)
                                            .frame(width: 180, height: 180).padding(13)
                                        
                                        Text(completeText).font(SpaceGroteskBold18)
                                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                } else {
                                    
                                    ScrollView{
                                        VStack {
                                            Text(product.name)
                                                .font(SpaceGroteskBold14)
                                                .multilineTextAlignment(.leading)
                                                .padding(.bottom, 10)
                                            
                                            
                                            HStack(alignment: .center) {
                                                Image(uiImage: SCIcon(sysName: "info.circle.fill")!).resizable().frame(width: 15, height: 15).foregroundColor(colorPrimary)
                                                
                                                Text("Enter details as it appears on legal documents")
                                                    .font(spaceGroteskRegular13)
                                                
                                                
                                            }.padding(9).frame(alignment: .leading).background(colorPrimaryTrans)
                                            
                                            HStack {
                                                VStack{}.frame(maxWidth: .infinity)
                                                
                                                HStack(alignment: .center){
                                                    Text("Underwritten by: ").font(spaceGroteskRegularSM)
                                                    
                                                    let productLogo = SCImage(name: getLogo(prefix: product.prefix))
                                                    
                                                    if (( productLogo) != nil){
                                                        Image(uiImage: productLogo!)
                                                            .padding(.trailing, 10)
                                                    }else{
                                                        Text(product.prefix.capitalized).font(spaceGroteskRegularSM).padding(.top, 12)
                                                        
                                                    }
                                                }.padding(.top, 12)
                                                
                                            }
                                            
                                            
                                            VStack {
                                                let forms = formSet[currentFormSetIndex]
                                                ForEach(forms) {form in
                                                    
                                                    VStack(alignment: .leading) {
                                                        
                                                        if(form.input_type == InputType.date) {
                                                            
                                                            Text(form.label).font(spaceGroteskRegularSM)
                                                            
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
                                                            
                                                            
                                                            
                                                            
                                                        } else if(form.input_type == InputType.file) {
                                                            
                                                            
                                                            
                                                            if(form.label.lowercased().contains("image")){
                                                                
                                                                
                                                                Button(
                                                                    action: {
                                                                        formName = form.name
                                                                        selectProfileImage = true
                                                                        openCameraRoll = true
                                                                        
                                                                    }, label: {
                                                                        CustomTextField(
                                                                            label: form.label,
                                                                            inputType: resolveKeyboardType(inputType: form.input_type),
                                                                            hint: files[form.name]?.description ?? form.description,
                                                                            disabled: true,
                                                                            text: name
                                                                        )
                                                                        
                                                                    }
                                                                )
                                                            }else{
                                                                
                                                                FilePicker(types: [.data], allowMultiple: false) { urls in
                                                                    print("selected \(urls[0]) files")
                                                                    print(form.label)
                                                                    
                                                                    if (urls[0] != nil) {
                                                                        files[form.name] = urls[0]
                                                                    }
                                                                } label: {
                                                                    CustomTextField(
                                                                        label: form.label,
                                                                        inputType: resolveKeyboardType(inputType: form.input_type),
                                                                        hint: files[form.name]?.description ?? form.description,
                                                                        disabled: true,
                                                                        text: name
                                                                    )
                                                                }
                                                                
                                                                
                                                            }
                                                            
                                                            
                                                            
                                                        }
                                                        
                                                        else {
                                                            
                                                            if(form.form_field.name!.lowercased().contains("select")) {
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
                                                                            inputType: resolveKeyboardType(inputType: form.input_type),
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
                                                                    inputType: resolveKeyboardType(inputType: form.input_type),
                                                                    hint: form.description,
                                                                    disabled: false,
                                                                    text: "\(fields[form.name] as? String ?? "") ",
                                                                    //                                                                    text: test,
                                                                    onTap: {
                                                                        print("\(form.label) is \(fields[form.label] ?? "")")
                                                                    },
                                                                    onChange: {value in
                                                                        
                                                                        if(form.data_type == DataType.number) {
                                                                            fields[form.name] = Int(value.trimmingCharacters(in: .whitespacesAndNewlines))
                                                                        } else {
                                                                            fields[form.name] = value.trimmingCharacters(in: .whitespacesAndNewlines)
                                                                        }
                                                                        
                                                                        print(value.description)
                                                                        print("form field value \(form.data_type) \(fields[form.name] ?? "")")
                                                                        print("form field value \(form.data_type) \(form.name ?? "")")
                                                                        
                                                                        
                                                                        
                                                                        print(fields)
                                                                        
                                                                    }
                                                                )
                                                            }
                                                        }
                                                        
                                                        
                                                    }.padding(.vertical, 4).task {
                                                        let _: () = await getSelectField(form: form)
                                                    }.padding(.bottom, 5)
                                                    
                                                    
                                                }
                                            }.padding(.top,15)
                                            VStack {}.frame(maxHeight: .infinity)
                                        }
                                    } }
                                
                                
                                
                                
                                Button(buttonText) {
                                    if (currentFormSetIndex < formSet.count  - 1) {
                                        currentFormSetIndex += 1
                                    } else {
                                        if(initializedTransactionResponse != nil) {
                                            if(purchaseComplete) {
                                                if (Credential.onSuccess != nil){
                                                    Task{
                                                        Credential.onSuccess!()
                                                    }
                                                    
                                                }else{
                                                    done = true
                                                }
                                                
                                                
                                                //                                                done = true
                                            } else {
                                                Task {
                                                    await completePurchase()
                                                }
                                            }
                                            
                                        } else {
                                            fields["product_id"] = product.id
                                            
                                            if (Credential.paymentOption == "wallet"){
                                                
                                                Task {
                                                    await  initiateWalletPurchase()
                                                }
                                                
                                            }else{
                                                showPayment = true
                                            }
                                            
                                        }
                                    }
                                    print("index \(currentFormSetIndex) count \(formSet.count) \(formSet.indices)")
                                }
                                .font(SpaceGroteskBold14)
                                .foregroundColor(Color.white)
                                .padding(.vertical, 5)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                                .background(colorPrimary)
                                .clipShape(Capsule())
                                .padding(.vertical, 12)
                                
                            }
                                .padding(.horizontal, 25)
                            )
                        }
                                     
                        ).navigationBarHidden(true)
                    }
                    else {
                        //HERER
                        PaymentDetailsScreen(onBackPressed: {
                            showPayment.toggle()
                        },  product: product, fields: fields, files: files)
                    }
                }
                
                if(isBusy) {
                    LoadingOverlay(loadingText: "Please wait...")
                }
            }.sheet(isPresented: $openCameraRoll){
                ImagePicker(selectedImage: $selectedImage, files: $files, formName: $formName, imageUrl: $imageUrl)
            }.alert(isPresented: $showAlert) {
                Alert(
                    title: Text(responseTitle.isEmpty ? "Transaction Failed" :responseTitle),
                    message: Text(responseText),
                    dismissButton: .default(Text("Ok"))
                )
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


func resolveKeyboardType(inputType: String) -> UIKeyboardType {
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
