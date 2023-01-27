//
//  ContentView.swift
//  mca-ios-sdk
//

import SwiftUI


struct Hello: View {
    var body: some View {
        Text("Hello")
    }
}

struct ProductListView: View {
    
  //  @ObservedObject var viewModel: ProductListViewModel
    
    //@EnvironmentObject var network: NetworkService
    
    @EnvironmentObject var sample: Sample
    
    func getCompanies() ->  [String] {
        var companies = ["all"]
        
        for p in  sample.responseData.data.productDetails {
        
            let d = p.productDetailPrefix
            
            if !companies.contains(where: {$0 == d}) {
                companies.append(d)
            }
        }
        
        return companies
    }
    
    @State var selectedIndex: Int = 0
    
    
    var body: some View {
       // let state = viewModel.state
        
        let companies = getCompanies()
        
        let filteredList = sample.responseData.data.productDetails.filter{
            p in
             if(companies[selectedIndex] != "all") {
            return p.productDetailPrefix == companies[selectedIndex]
            } else { return true}
        }
     
        
        VStack {
            Text("Products Page").background()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center){
                ForEach(companies.indices) {
                    c in
                    Chips(systemImage: "", titleKey: companies[c], isSelected: c == self.selectedIndex, onTap: { self.selectedIndex = c })
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
                                .font(spaceGroteskBold)
                                .multilineTextAlignment(.leading)
                                
                                                             
                            Text(product.productDetailPrefix).font(.caption).foregroundColor(.gray)
                            
                        }.frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 0,
                            maxHeight: .infinity,
                            alignment: .topLeading
                          )
                        
                        
                        Text("N \(product.price)").font(Font.custom("",size: 13)).bold()
                    }.background(NavigationLink("", destination:
                                                    ProductInfoScreen(product: product)).opacity(0))
                    .listRowSeparator(.hidden)
                }
    
            }
            
        }.onAppear {
           // network.getProducts()
        }.navigationBarHidden(true)
            .background(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Hello()
    }
}
