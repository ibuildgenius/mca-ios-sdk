//
//  NetworkService.swift
//  mca-ios-sdk
//

import Foundation
import Combine

protocol NetworkServiceable {
    func getProducts()
    
}

class NetworkService: NetworkServiceable, ObservableObject {
    
    @Published var products: [ProductDetail] = []
    
    
    let dummyResponse = ProductListResponse(responseCode: 0, responseText: "sample response text", data: DataClass(businessDetails: nil, productDetails:   []))
    
    let baseURLString: String
    
    init(baseURLString: String) {
           self.baseURLString = baseURLString
    }
    
    func getProducts() {
        
        let urlString = "\(baseURLString)/v1/sdk/initialize"

        guard let url = URL(string: urlString) else { print("url error occurred"); fatalError() }
        
        var request = URLRequest(url: url)
        
        let json = ["payment_option": "gateway", "action": "purchase"]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json)
        
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("Authorization", forHTTPHeaderField: "Bearer \(APIKEY)")
        request.setValue("Content-Type", forHTTPHeaderField: "application/json")
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("\n\n\n\n A Server error occurred \n \(error) \n\n\n")
                
                guard let response = response as? HTTPURLResponse else { return }
                
                print("\n\n\n\n status code \(response.statusCode)")
                
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                            DispatchQueue.main.async {
                                do {
                                    let decodedUsers = try JSONDecoder().decode(ProductListResponse.self, from: data)
                                    
                                    self.products = decodedUsers.data.productDetails
                                 
                                } catch let error {
                                    print("Error decoding: ", error)
                                }
            }
            } else {
                print("\n\n\n\n status code \(response.statusCode)")
            }
            
        }
        
        task.resume()
    
    }
}
