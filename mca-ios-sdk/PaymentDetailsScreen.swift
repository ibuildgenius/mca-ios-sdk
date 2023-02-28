//
//  PaymentDetailsScreen.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 03/02/2023.
//

import SwiftUI
import AnyCodable
import SwiftUI_NotificationBanner

enum Display {
    case transactionType
    case bankList
    case bankDetails
    case paymentSuccess
    case completeForm
    
}

struct PaymentDetailsScreen: View {
    let onBackPressed: (() -> Void)
    let product: ProductDetail
    let fields: [String: Any]
    let files: [String: URL]
    
   @EnvironmentObject var notificationHandler:  DYNotificationHandler
    
    @State private var display = Display.transactionType
    
    @State private var buttonText = "Continue"
    
    @State private var bankDetails: [String: Any] = [:]
    
    @State private var banks: [Bank] = []
    
    @State private var isBusy = false
    
    @State private var price: String? = nil
    
    @State private var isTransfer = true
    
    @State private var selectedBank: Bank? = nil
    
    @State private var responseText = ""
    @State private var showAlert = false
    @State private var transactionRes: TransactionResponse? = nil
    
    func format(payload: [String: Any]) -> [String: Any] {
        let defaults = UserDefaults.standard
        
        var channel = ["channel": isTransfer ? "bank transfer" : "ussd"]
        
        if(!isTransfer) {
            channel["bank_code"] = selectedBank?.code
        }
        
        let paymentPayload: [String: Any] = ["payload": payload, "instance_id": defaults.string(forKey: DefaultsKeys.instanceId) ?? "", "payment_channel": channel]
        
        return paymentPayload
    }
    
    
    
    func getFilteredBanks() -> [Bank] {
        return banks.filter{ $0.isValid()}
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
    
    func initiatePurchase() async {
        isBusy = true
        
        let payload = await uploadFiles()
        let result = await networkService.intiatePurchase(payload: format(payload: payload))
        isBusy = false
       
        let code = result!["responseCode"]!.value as! Int
        
        
        if(result != nil && code == 1) {
            buttonText = "I have sent the money"
            bankDetails = result!["data"]!.value as! [String: Any]
            price = String(bankDetails["amount"] as! Int)
            display = Display.bankDetails
            
            if((bankDetails["reference"] as? String) != nil) {
                listenForPaymentUpdate(ref: bankDetails["reference"] as! String)
            }
        } else {
        
            let rsText = (result!["responseText"]!).value as! String
            
            print("failed \(responseText)")
            
            responseText = rsText
            
            showAlert = true
            
            
        
        }
    }
    
    private func verifyTransaction() async {
        
        let ref = ( bankDetails["reference"] as! String)
        
        let response = await networkService.verifyTransaction(reference: ref)
        
        if response != nil && (response!.responseText.contains("Verified successfully")) {
            
            display = Display.paymentSuccess
            transactionRes = response
            buttonText = "Continue"
        }
    }
    
//    private func retryTransaction() async {
//        let timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { timer in
//
//           shouldRetry = true
//        }
//    }
    
    var body: some View {
        
      
        if(display == Display.completeForm) {
            ProductForms(product: product, transactionResponse: transactionRes, data: fields)
        }
        else {
            ZStack {
                PageTemplate(onBackPressed: onBackPressed, mContent: {
                    
                    print("\n\nfields is \(fields)\n\n")
                    
                    return AnyView(VStack {
                        VStack(alignment: .leading) {
                            
                            VStack(alignment: .leading) {
                                
                                if(display != Display.paymentSuccess) {
                                    VStack(alignment: .trailing) {
                                        Text((fields["email"] as? String) ?? "").font(metropolisRegular).foregroundColor(Color.gray)
                                        HStack{
                                            Text("Pay").font(metropolisRegular).foregroundColor(Color.gray);
                                            
                                            Text("N\(price ?? product.price)")
                                            
                                        }
                                        .padding(.vertical, 0.2).font(metropolisBold14)
                                        .foregroundColor(colorPrimary)
                                        
                                    }.frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(12)
                                        .background(colorPrimaryTrans)
                                        .padding(.vertical, 15)
                                }
                    
                                if(display == Display.bankDetails) {
                                    VStack(alignment: .center) {
                                        Text("\(bankDetails["message"]! as! String)").foregroundColor(colorPrimary)
                                            .multilineTextAlignment(.center)
                                        Divider().padding(.vertical, 8)
                                        
                                        if(isTransfer) {
                                            Text("\(bankDetails["bank"] as! String)\n\(bankDetails["account_number"] as! String)").padding(.vertical, 15).font(metropolisBold18).multilineTextAlignment(.center).lineSpacing(10)
                                            Text("").padding(.vertical, 15).font(metropolisBold18).multilineTextAlignment(.center).lineSpacing(10)
                                        } else {
                                            Text("\(selectedBank!.name)\n\(bankDetails["ussd_code"] as! String)").padding(.vertical, 15).font(metropolisBold18).multilineTextAlignment(.center).lineSpacing(10).frame(maxWidth: .infinity)
                                            Text("\(bankDetails["ussd_code"] as! String)").padding(.vertical, 15).font(metropolisBold18).multilineTextAlignment(.center).lineSpacing(10).frame(maxWidth: .infinity)
                                            Text(" \(selectedBank!.currency.uppercased()) \(price!)").padding(.vertical, 15).font(metropolisBold18).multilineTextAlignment(.center).lineSpacing(10)
                                        }
                                        
                                    
                                        Divider().padding(.vertical, 8)
                                    }.frame(maxWidth: .infinity).padding(18).background(colorGrey)
                                }
                                
                                if(display == Display.transactionType) {
                                    
                                    Text("Select Payment method").font(metropolisBold25)
                                    
                                    Text("Choose an option to proceed").font(metropolisRegular13).padding(.vertical, 2).foregroundColor(Color.gray)
                                    
                                   
                                    PaymentMethodCard(title: "Transfer", description: "Send to a bank Account", isSelected: isTransfer, image: "transfer").onTapGesture {
                                        isTransfer = true
                                    }
                                    PaymentMethodCard(title: "USSD", description: "Select any bank to generate USSD", isSelected: !isTransfer, image: "ussd").onTapGesture {
                                        isTransfer = false
                                    }
                                    
                                }
                                
                                if(display == Display.bankList) {
                                    
                                    Text("Select a bank of your choice")
                                        .padding(.vertical, 5).font(metropolisBold16)
                                    VStack(alignment: .leading) {
                                        ScrollView(.vertical) {
                                            VStack(alignment: .leading){
                                                ForEach(getFilteredBanks()) { bank in
                                                    
                                                    HStack() {
                                                        Text("\(bank.name) (\(bank.currency))").multilineTextAlignment(.leading)
                            
                                                            .font(metropolisMedium)
                                                        HStack{}.frame(maxWidth: .infinity)
                                                        if(selectedBank?.code == bank.code) {
                                                            Image(systemName: "checkmark").foregroundColor(colorPrimary)
                                                        }
                                                    }
                                                    .padding(.vertical, 10)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.horizontal,4)
                                                    .onTapGesture {
                                                        selectedBank = bank
                                                    }.background(selectedBank?.code == bank.code ? Color.white : colorPrimaryTrans)
                                                    
                                                }
                                            }
                                            
                                        }.padding(12)
                                    }.frame(maxWidth: .infinity, maxHeight: 280, alignment: .leading).background(colorPrimaryTrans)
                                       
                                }
                                
                                if(display == Display.paymentSuccess) {
                                    VStack {
                                        LottieView(lottieFile: "check", loopMode: .playOnce)
                                            .frame(width: 180, height: 180).padding(13)
                                        Text("Payment verified").font(metropolisBold18)
                                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                }
                                
                            
                                
                                
                                             
                            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            
                        
                            Button(buttonText) {
                                
    //                            Task {
    //                                await verifyTransaction()
    //                            }
                               
                                if(display == Display.transactionType && !isTransfer) {
                                    display = Display.bankList
                                }
                                else if(display == Display.bankDetails) {
                                    Task {
                                     await verifyTransaction()
                                    }
                                }
                                else if(display == Display.paymentSuccess) {
                                    display = Display.completeForm
                                }
                                else {
                                    Task {
                                        await initiatePurchase()
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .foregroundColor(.white)
                                .background(colorPrimary)
                                .clipShape(Capsule())
                            
                            
                        }.padding(.horizontal, 12)
                    })
                    
                }).navigationBarHidden(true).task {
                    let result = await networkService.getBanks()
                    
                    if(result != nil && ((result?.responseText.contains("Banks retrieved")) != nil)) {
                        banks = result!.data.banks
                        selectedBank = getFilteredBanks()[0]
                    }
                    
                }
                
                if(isBusy) {
                 
                   LoadingOverlay(loadingText: "Please  wait...")
                }
            }   .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Transaction Failed"),
                    message: Text(responseText),
                    dismissButton: .default(Text("Ok"))
                )
            }
        }
    }
}



