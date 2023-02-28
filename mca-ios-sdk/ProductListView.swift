//
//  ContentView.swift
//  mca-ios-sdk
//

import SwiftUI


struct DefaultsKeys {
    static let instanceId = "instanceId"
}


struct ProductListView: View {
    
    @State private var productList: [ProductDetail] = []
    @State private var isLoading = false;
    @State private var companies: [String] = []
    
    //@EnvironmentObject var sample: Sample
    
    func getCompanies() ->  [String] {
        var companies = ["all"]
        
        for p in  productList.filter({ !$0.formFields.isEmpty}) {
        
            let d = p.productDetailPrefix
            
            if !companies.contains(where: {$0 == d}) {
                companies.append(d)
            }
        }
        
        return companies
    }
    
    @State var selectedIndex: Int = 0

    var body: some View {
        
        let filteredList = productList.filter{
            p in
            
             if(companies[selectedIndex] != "all") {
            return p.productDetailPrefix == companies[selectedIndex]
            } else { return true}
        }.filter{ !$0.formFields.isEmpty }
     
        VStack {
            Text("Products Page").font(metropolisBold).padding(.vertical, 12)
            
            if(isLoading) {
                VStack(alignment: .center) {
                    Text("Fetching products, please wait..").padding(12).font(metropolisRegular)
                    ProgressView()
                }.frame(maxHeight: .infinity, alignment: .center)
               
            } else {
                
                VStack {
                           ScrollView(.horizontal, showsIndicators: false) {
                                         HStack(alignment: .center){
                                             
                                             ForEach(companies, id: \.self) {
                                             c in
                                                 Chips(systemImage: "", titleKey: c, isSelected: companies.firstIndex(of: c) == self.selectedIndex, onTap: { self.selectedIndex = companies.firstIndex(of: c)! })
                                         }
                                         
                                         }.padding(.top, 13)
                                     }.frame(height: 40).padding(.horizontal, 12)
                                     
                                     
                                     List {
                                         ForEach(filteredList.indices, id: \.self) {
                                             x in
                                             
                                             let product  = filteredList[x]
                                             
                                             HStack {
                                                 Image(systemName: "house.fill").renderingMode(.template)
                                                     .foregroundColor(Color("mcgTeal"))
                                                     .padding(0)
                                                 
                                                 VStack(alignment: .leading, spacing: 10) {
                                                     Text(product.name)
                                                         .font(metropolisBold14)
                                                         .multilineTextAlignment(.leading)
                                                         
                                                                                      
                                                     Text(product.productDetailPrefix.capitalized).font(metropolisRegularSM).foregroundColor(.gray)
                                                     
                                                 }.frame(
                                                     minWidth: 0,
                                                     maxWidth: .infinity,
                                                     minHeight: 0,
                                                     maxHeight: .infinity,
                                                     alignment: .topLeading
                                                   )
                                                 
                                                 let price = Double(product.price)!
                                                 
                                                 if(price < 1000.0) {
                                                     Text("\(product.price)%").font(metropolisMedium)
                                                 } else {
                                                     Text("N\(product.price)").font(metropolisMedium)
                                                 }
                                             }.background(NavigationLink("", destination:ProductInfoScreen(product: product)))
                                             .listRowSeparator(.hidden)
                                         }
                             
                                     }
                       }
            }
            
       
          
            
        }.task {
            if(productList.isEmpty) {
                isLoading = true
                var response = await networkService.getProducts()
                productList = response?.productDetails ?? []
                
                let defaults = UserDefaults.standard
                
                defaults.set(response?.businessDetails?.instanceID, forKey: DefaultsKeys.instanceId)
                
                companies = getCompanies()
                isLoading = false
            }
        }.navigationBarHidden(true)
            .background(.white)
    }
}


