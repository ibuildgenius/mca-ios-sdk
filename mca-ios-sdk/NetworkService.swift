//
//  NetworkService.swift
//  mca-ios-sdk
//

import Foundation
import Combine
import AnyCodable

protocol NetworkServiceable {
    func getProducts() async  -> DataClass?
    func intiatePurchase(payload: [String: Any]) async -> [String: Any]?
    func getBanks() async -> BankResponse?
    func getSelectFieldOptions(url: String) async -> SelectResponse?
    func verifyTransaction(reference: String) async -> TransactionResponse?
    func uploadFile(file: URL) async -> String?
    
}

fileprivate extension URLRequest {
    func debug() {
        print("\(self.httpMethod!) \(self.url!)")
        print("Headers:")
        print(self.allHTTPHeaderFields!)
        print("Body:")
        print(String(data: self.httpBody ?? Data(), encoding: .utf8)!)
    }
}

class NetworkService: NetworkServiceable {
    
    
    func uploadFile(file: URL) async -> String? {
        let urlString = "\(baseURLString)/v1/sdk/verify-transaction"

        guard let url = URL(string: urlString) else { print("url error occurred"); return nil }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "post"
        request.setValue("Bearer \(APIKEY)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.debug()
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, fromFile: file)
            
            do {
                let x = try JSONDecoder().decode(TransactionResponse.self,  from: data)
                print(x)
                return "success"
            } catch {
                print(error)
            }
            
        } catch {
            print(error)
        }
        
     
        
        
        return nil
    }
    
    
    func verifyTransaction(reference: String) async -> TransactionResponse? {
        let urlString = "\(baseURLString)/v1/sdk/verify-transaction"

        guard let url = URL(string: urlString) else { print("url error occurred"); return nil }
        
        var request = URLRequest(url: url)
        
        let bodyJson = try! JSONSerialization.data(withJSONObject: ["transaction_reference": reference])
        
        request.httpMethod = "post"
        request.setValue("Bearer \(APIKEY)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyJson
        do {
            
            request.debug()
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            do {
                let x = try JSONDecoder().decode(TransactionResponse.self,  from: data)
                print(x)
                return x
            } catch {
                print(error)
            }
            
        } catch {
            print("Invalid data")
        }
    
        return nil
    }
    
    
    func getSelectFieldOptions(url: String) async -> SelectResponse? {
        
        let urlString = "\(baseURLString)/v1\(url)"

        guard let url = URL(string: urlString) else { print("url error occurred"); return nil }
        
        var request = URLRequest(url: url)
        
        
        request.httpMethod = "get"
        request.setValue("Bearer \(APIKEY)", forHTTPHeaderField: "Authorization")
        do {
            
            request.debug()
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            
            
            do {
                let x = try JSONDecoder().decode(SelectResponse.self,  from: data)
                
                return x
            } catch {
                print(error)
            }
            
        } catch {
            print("Invalid data")
        }
        
        return nil
    }
    
    
    @Published var products: [ProductDetail] = []
    
    
    let baseURLString: String
    
    init(baseURLString: String) {
           self.baseURLString = baseURLString
    }
    
    
    
    func getBanks() async -> BankResponse? {
        let urlString = "\(baseURLString)/v1/bank/list-banks"

        guard let url = URL(string: urlString) else { print("url error occurred"); return nil }
        
        var request = URLRequest(url: url)
        
        
        request.httpMethod = "get"
        request.setValue("Bearer \(APIKEY)", forHTTPHeaderField: "Authorization")
        do {
            
            request.debug()
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            
            
            do {
                let x = try JSONDecoder().decode(BankResponse.self,  from: data)
                
                return x
            } catch {
                print(error)
            }
            
        } catch {
            print("Invalid data")
        }
    return nil
    }
    
    
    
    
    
    func intiatePurchase(payload: [String: Any]) async -> [String : Any]? {
        let urlString = "\(baseURLString)/v1/sdk/initiate-purchase"

        guard let url = URL(string: urlString) else { print("url error occurred"); return nil }
        
        var request = URLRequest(url: url)
        
        let jsonData = try! JSONSerialization.data(withJSONObject: payload)
        
        request.httpMethod = "post"
        request.httpBody = jsonData
        request.setValue("Bearer \(APIKEY)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            
            request.debug()
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            
            if let decodedResponse = try? JSONDecoder().decode([String: AnyDecodable].self,  from: data) {
                
                let text = (decodedResponse["responseText"]!).value as! String
                
                print("decoded response \(decodedResponse)")
                return decodedResponse
            } else {
                print("cannot parse \(data)")
            }
            
        } catch {
            print("Invalid data")
        }
    return nil
    }
    
    func getProducts() async -> DataClass? {
        
        let urlString = "\(baseURLString)/v1/sdk/initialize"

        guard let url = URL(string: urlString) else { print("url error occurred"); return nil }
        
        var request = URLRequest(url: url)
        
        let json = ["payment_option": "gateway", "action": "purchase"]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json)
        
        request.httpMethod = "post"
        request.httpBody = jsonData
        request.setValue("Bearer \(APIKEY)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        do {
            
            request.debug()
            
            let (data, _) = try await URLSession.shared.upload(for: request, from: jsonData)
            
            if let decodedResponse = try? JSONDecoder().decode(ProductListResponse.self, from: data) {
                return decodedResponse.data
            }
        } catch {
            print("Invalid data")
        }
    return nil
    }
}
