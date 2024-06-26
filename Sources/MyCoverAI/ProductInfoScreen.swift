//
//  ProductInfoScreen.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 25/01/2023.
//

import SwiftUI

struct ProductInfoScreen: View {
    let product: ProductDetail
    
    @State private var currentPage: Int = 0
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    func continueButton() -> some View {
        VStack {
            Text("Continue")
                .font(SpaceGroteskBold14)
                .foregroundColor(Color.white)
               
        }
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .foregroundColor(.white)
        .background(colorPrimary)
        .clipShape(Capsule())
        .padding(12)
    }
    
    var body: some View {
        
        // data to draw TabLayout View
              let titles = ["How it Works", "Benefits", "How to claim"]
        let sModel = SelectedTabDataModel(textColor: colorPrimary, backgroundColor: colorPrimary.opacity(0.1), borderColor: colorPrimary, borderWidth: 0.1, cornerRadius: 0)
        let uModel = UnSelectedTabDataModel(textColor: .gray, backgroundColor: Color.white, borderColor: .gray, borderWidth: 0.1, cornerRadius: 0)
              let dataModel = TabDataModel(tabTitles: titles, spacingBetweenTabs: 4, paddingLeftRight: 4, selectedTabDataModel: sModel, unselectedTabDataModel: uModel)
        
        
        
        if(false) {
            FileUpload()
        } else {
            VStack {
                PageTemplate(onBackPressed: { presentationMode.wrappedValue.dismiss() }, mContent: { return
                    
                    
                    AnyView( VStack {
                        VStack {
                            // Add TabLayoutView
                            TabLayoutView(dataModel: dataModel, action: { index in
                                print("TabLayoutView tab tapped index: \(index)")
                                self.currentPage = index
                            })
                            .frame(height: 40).padding(.horizontal, 15)
                            
                            TabView(selection: $currentPage) {
                                ForEach(0..<titles.count) { index in
                                    
                                    switch(index) {
                                    case 0:
                                        PageView(image: "how_it_works", content: product.how_it_works)
                                    case 1:
                                        PageView(image: "benefits", content:  "\(product.key_benefits?.value ?? "")")
                                    case 2:
                                        PageView(image: "how_to_claim", content: product.how_to_claim)
                                    default:
                                        PageView(image: "how_to_claim", content: "Opp! you're in limbo")
                                    }
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                            .animation(.easeIn)
                            
                            
                        }.frame(maxHeight: .infinity)
                        
                        
                        
                        if(product.form_fields.isEmpty) {
                            
                            NavigationLink(destination: PaymentDetailsScreen(onBackPressed: {presentationMode.wrappedValue.dismiss()}, product: product, fields: [:], files: [:])) {
                                
                                continueButton()
                                
                            }
                            
                        }else {
                            NavigationLink(destination: ProductForms(product: product, transactionResponse: nil, data: nil)) {
                                continueButton()
                                
                            }
                        }
                    })
                })
                
                
            }.navigationBarHidden(true)
        }
        
    }
}

