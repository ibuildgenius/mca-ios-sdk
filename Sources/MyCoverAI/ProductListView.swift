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
    @State private var searchText = "";
    @State private var companies: [String] = []
    
    @State private var responseText = ""
    @State private var responseTitle = ""
    @State private var showAlert = false
    
    //@EnvironmentObject var sample: Sample
    
    func getCompanies() ->  [String] {
        var companies = ["all"]
        
        for p in  productList.filter({ !$0.form_fields.isEmpty}) {
            
            let d = p.prefix
            
            if !companies.contains(where: {$0 == d}) {
                companies.append(d)
            }
        }
        
        return companies
    }
    
    func getImages(category: String) -> String {
        let lowercaseCategory = category.lowercased()
        
        if lowercaseCategory.contains("auto") || lowercaseCategory.contains("life") {
            return "auto"
        } else if lowercaseCategory.contains("health") {
            return "health"
        } else if lowercaseCategory.contains("travel") {
            return "travel"
        } else if lowercaseCategory.contains("gadget") || lowercaseCategory.contains("home") || lowercaseCategory.contains("content") {
            return "gadget"
        } else {
            return "auto"
        }
    }
    
    func checkDecimalValue(_ value: String) -> String {
        if let decimalIndex = value.firstIndex(of: ".") {
            let decimalPart = value.suffix(from: decimalIndex)
            if decimalPart == ".00" {
                return String(value.prefix(upTo: decimalIndex))
            } else {
                return value
            }
        } else {
            return value
        }
    }
    
    func fetchPolicies() async {
        isLoading = true
        let response = await networkService.getProducts()
        //        debugPrint(response)
        if(response?.responseCode == 1){
            productList = response?.data?.productDetails ?? []
            
            let defaults = UserDefaults.standard
            
            defaults.set(response?.data?.businessDetails?.instance_id, forKey: DefaultsKeys.instanceId)
            
            companies = getCompanies()
            isLoading = false
            
        }else{
            isLoading = false
            responseText = response?.responseText ?? ""
            showAlert = true
        }
        
        
        
        
        
    }
    
    @State var selectedIndex: Int = 0
    
    var body: some View {
        
        let filteredList = productList.filter{
            p in
            
            if(!companies.isEmpty) {
                if(companies[selectedIndex] != "all") {
                    return p.prefix == companies[selectedIndex]
                }
                if !searchText.isEmpty {
                    return p.name.lowercased().contains(searchText.lowercased())
                }
            }
            
            return true
        }.filter{ !$0.form_fields.isEmpty }
        
        NavigationView{
            ZStack{
                bgWhite.ignoresSafeArea()
                VStack {
                    Text("Products Page").font(SpaceGroteskBold20).padding(.vertical, 12)
                    
                    
                    SearchTextField(
                        hint: "Search Products",
                        disabled: true,
                        text: searchText,
                        onChange: {value in
                            searchText = value
                            
                        }
                    ).padding(.horizontal, 18).padding(.bottom, 5)
                    
                    if(isLoading) {
                        VStack(alignment: .center) {
                            Text("Fetching products, please wait..").padding(12).font(spaceGroteskRegular)
                            ProgressView()
                        }.frame(maxHeight: .infinity, alignment: .center)
                        
                    } else if(!isLoading && filteredList.isEmpty) {
                        VStack(alignment: .center) {
                            Text("Unable to fetch Policies").padding(12).font(spaceGroteskRegular)
                            
                            Button("Retry") {
                                Task {
                                    await fetchPolicies()
                                }
                            }
                            
                        }.frame(maxHeight: .infinity, alignment: .center)
                    }
                    
                    else {
                        
                        
                        VStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(alignment: .center){
                                    
                                    ForEach(companies, id: \.self) {
                                        c in
                                        Chips(systemImage: "",
                                              titleKey: c, isSelected: companies.firstIndex(of: c) == self.selectedIndex,
                                              onTap: { self.selectedIndex = companies.firstIndex(of: c)! }
                                        )
                                    }
                                }.padding(.top, 8)
                            }.padding(.horizontal, 12)
                            
                            Spacer(minLength: 30)
                            List {
                                ForEach(filteredList.indices, id: \.self) {
                                    x in
                                    
                                    let product  = filteredList[x]
                                    
                                    HStack (alignment: .center) {
                                        Image(uiImage: SCImage(name: getImages(category: product.productCategory.name))!)
                                            .resizable()
                                            .frame(width: 35, height: 35)
                                            .padding(.trailing, 10)
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text(product.name)
                                                .font(SpaceGroteskBold14)
                                                .multilineTextAlignment(.leading)
                                            
                                            HStack{
                                                Text(product.prefix.capitalized).font(spaceGroteskRegularSM).foregroundColor(filterTextColor)
                                                
                                                let productLogo = SCImage(name: getLogo(prefix: product.prefix))
                                                
                                                if (( productLogo) != nil){
                                                    Image(uiImage: productLogo!)
                                                    //                                                        .resizable()
                                                    //                                                        .frame(width: 35, height: 35)
                                                        .padding(.trailing, 10)
                                                }else{
                                                    Text(product.prefix.capitalized).font(SpaceGroteskBold14).foregroundColor(.black)
                                                    
                                                }
                                                
                                                
                                            }
                                            
                                            
                                            
                                        }
                                        Spacer()
                                        
                                        let price = Double(product.price)!
                                        
                                        
                                        if(price < 1000.0) {
                                            Text("\(checkDecimalValue(product.price))%").font(SpaceGroteskBold14)
                                        } else {
                                            Text("N\(formatNumbers(number: price))").font(SpaceGroteskBold14)
                                        }
                                    }
                                    .padding()
                                    .background(.white)
                                    .cornerRadius(2)
                                    .shadow(color: shadowColor, radius: 1, y: 2)
                                    .background(NavigationLink("", destination:ProductInfoScreen(product: product)))
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(bgWhite)
                                    .listRowInsets(.init(top: 0,leading: 20,bottom: 15, trailing: 20))
                                }
                                
                            }.listStyle(.plain)
                                .background(bgWhite)
                            
                        }
                    }
                }
                
            }
            
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(responseTitle.isEmpty ? "Unable to fetch Policies" :responseTitle),
                    message: Text(responseText),
                    dismissButton: .default(Text("Ok"))
                )
            }
            
        }
        
        .task {
            if(productList.isEmpty) {
                await fetchPolicies()
            }
        }.navigationBarHidden(true).navigationTitle("")
            .background(bgWhite)
    }
}


