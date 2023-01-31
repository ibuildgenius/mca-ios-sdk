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
    
    var body: some View {
        
        // data to draw TabLayout View
              let titles = ["How it Works", "Benefits", "How to claim"]
        let sModel = SelectedTabDataModel(textColor: pColor, backgroundColor: pColor.opacity(0.1), borderColor: pColor, borderWidth: 0.1, cornerRadius: 0)
        let uModel = UnSelectedTabDataModel(textColor: .gray, backgroundColor: Color.white, borderColor: .gray, borderWidth: 0.1, cornerRadius: 0)
              let dataModel = TabDataModel(tabTitles: titles, spacingBetweenTabs: 4, paddingLeftRight: 4, selectedTabDataModel: sModel, unselectedTabDataModel: uModel)
        
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
                                           PageView(image: "how_it_works", content: product.howItWorks)
                                       case 1:
                                           PageView(image: "benefits", content: product.keyBenefits)
                                       case 2:
                                           PageView(image: "how_to_claim", content: product.howToClaim)
                                           
                                       default:
                                           PageView(image: "how_to_claim", content: "Opp! you're in limbo")
                                       }
                                   }
                               }
                               .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                               .animation(.easeIn)
                               
                               
                           }.frame(maxHeight: .infinity)
                           
                           
                           NavigationLink(destination: ProductForms(product: product)) {
                               VStack {
                                   Text("Continue")
                                       .foregroundColor(Color.white)
                                       .padding(.vertical, 9)
                                      
                               }
                               .frame(maxWidth: .infinity)
                               .background(pColor)
                               .padding(12)
                               
                           }})
                    
                    
                    })
            
        
            }.navigationBarHidden(true)
        
    }
}

