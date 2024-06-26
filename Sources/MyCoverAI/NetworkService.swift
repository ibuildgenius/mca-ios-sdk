//
//  NetworkService.swift
//  mca-ios-sdk
//

import Foundation
import Combine
import AnyCodable
import UIKit
import Alamofire



protocol NetworkServiceable {
    func getProducts() async  -> ProductListResponse?
    func intiatePurchase(payload: [String: Any]) async -> [String: AnyDecodable]?
    func getBanks() async -> BankResponse?
    func getSelectFieldOptions(url: String) async -> SelectResponse?
    func verifyTransaction(reference: String) async -> TransactionResponse?
    func uploadFile(file: URL) async -> UploadResponse?
    func completePurchase(payload: [String: Any]) async -> [String: AnyDecodable]?
    func initiateWalletPurchase(formData: [String: Any]) async -> WalletTransactionResponse?
    
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
    
    private let decoder = JSONDecoder()
    //
    func initiateWalletPurchase(formData: [String : Any]) async -> WalletTransactionResponse?{
        if(Credential.APIKEY.isEmpty) {
            return nil
        }
        let defaults = UserDefaults.standard
        let payload: [String : Any] =
        [
            "instance_id": defaults.string(forKey: DefaultsKeys.instanceId) ?? "",
            "reference": Credential.reference,
            "payload": formData,
        ]
        let urlString = "\(baseURLString)/v1/sdk/initiate-purchase"
        
        guard let url = URL(string: urlString) else { print("url error occurred"); return nil }
        
        var request = URLRequest(url: url)
        
        let jsonData = try! JSONSerialization.data(withJSONObject: payload)
        
        request.httpMethod = "post"
        request.httpBody = jsonData
        request.setValue("Bearer \(Credential.APIKEY)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            
            request.debug()
            
            let (data, response) = try await URLSession.shared.data(for: request)
//            
            if let decodedResponse = try? JSONDecoder().decode(WalletTransactionResponse.self,  from: data) {  
                
                
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
    
    
    func completePurchase( payload: [String : Any]) async -> [String : AnyDecodable]? {
     
        print(payload)
        if(Credential.APIKEY.isEmpty) {
            return nil
        }
        
        
        let urlString = "\(baseURLString)/v1/sdk/complete-purchase"
        
        guard let url = URL(string: urlString) else { print("url error occurred"); return nil }
        
        var request = URLRequest(url: url)
        
        let jsonData = try! JSONSerialization.data(withJSONObject: payload)
        
        request.httpMethod = "post"
        request.httpBody = jsonData
        request.setValue("Bearer \(Credential.APIKEY)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            
            request.debug()
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let decodedResponse = try? JSONDecoder().decode([String: AnyDecodable].self,  from: data) {            
                
                
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
    
    func uploadFile(file: URL) async -> UploadResponse? {
        
        if(Credential.APIKEY.isEmpty) {
            return nil
        }
        
        let dispatch = DispatchSemaphore(value: 0)
        
        //DOCUMENT TYPE: document, video, image, blob
        
        var result: UploadResponse? = nil
        
        let urlString = "\(baseURLString)/v1/upload-file"
        
        
        let bodyJson = try! JSONSerialization.data(withJSONObject: ["fileType": "image"])
        
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer \(Credential.APIKEY)",
            "Accept": "application/json"
        ]
        
        let im = try! Data(contentsOf: file)
        //let image = UIImage(data: im)
        
        AF.upload(multipartFormData: {multipartFormData in
            multipartFormData.append(im, withName: "file", fileName: "image.png", mimeType: "image/png")
            multipartFormData.append("image".data(using: .utf8)!, withName: "fileType")
            
        }, to: urlString, method: .post, headers: headers)
        .response {
            response in
            let data = try! JSONDecoder().decode(UploadResponse.self,  from: response.data!)
            
            result = data
            dispatch.signal()
            
            print("video upload response \(data)")
        }
        
        dispatch.wait()
        return result
    }
    
    
    func verifyTransaction(reference: String) async -> TransactionResponse? {
        if(Credential.APIKEY.isEmpty) {
            return nil
        }
        
        let urlString = "\(baseURLString)/v1/sdk/verify-transaction"
        
        guard let url = URL(string: urlString) else { print("url error occurred"); return nil }
        
        var request = URLRequest(url: url)
        
        let bodyJson = try! JSONSerialization.data(withJSONObject: ["transaction_reference": reference])
        
        request.httpMethod = "post"
        request.setValue("Bearer \(Credential.APIKEY)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyJson
        do {
            
            request.debug()
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            print(data)
            
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
        
        if(Credential.APIKEY.isEmpty) {
            return nil
        }
        
        let urlString = "\(baseURLString)/v1\(url)"
        
        guard let url = URL(string: urlString) else { print("url error occurred"); return nil }
        
        var request = URLRequest(url: url)
        
        
        request.httpMethod = "get"
        request.setValue("Bearer \(Credential.APIKEY)", forHTTPHeaderField: "Authorization")
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
    
    let baseURLString: String
    
    init(baseURLString: String) {
        self.baseURLString = baseURLString
        //decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    
    
    func getBanks() async -> BankResponse? {
        if(Credential.APIKEY.isEmpty) {
            return nil
        }
        let urlString = "\(baseURLString)/v1/bank/list-banks"
        
        guard let url = URL(string: urlString) else { print("url error occurred"); return nil }
        
        var request = URLRequest(url: url)
        
        
        request.httpMethod = "get"
        request.setValue("Bearer \(Credential.APIKEY)", forHTTPHeaderField: "Authorization")
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
    
    
    func intiatePurchase(payload: [String: Any]) async -> [String : AnyDecodable]? {
        if(Credential.APIKEY.isEmpty) {
            return nil
        }
        let urlString = "\(baseURLString)/v1/sdk/initiate-purchase"
        
        guard let url = URL(string: urlString) else { print("url error occurred"); return nil }
        
        var request = URLRequest(url: url)
        
        let jsonData = try! JSONSerialization.data(withJSONObject: payload)
        
        request.httpMethod = "post"
        request.httpBody = jsonData
        request.setValue("Bearer \(Credential.APIKEY)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            
            request.debug()
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            
            if let decodedResponse = try? JSONDecoder().decode([String: AnyDecodable].self,  from: data) {
                
                
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
    
    
    func getProducts() async -> ProductListResponse? {
        if(Credential.APIKEY.isEmpty) {
            return nil
        }
        
        let urlString = "\(baseURLString)/v1/sdk/initialize"
        
        guard let url = URL(string: urlString) else { print("url error occurred"); return nil }
        
        var request = URLRequest(url: url)
        
        let json = ["payment_option": Credential.paymentOption, "action": "purchase", "debit_wallet_reference": Credential.reference]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json)
        
        request.httpMethod = "post"
        request.httpBody = jsonData
        request.setValue("Bearer \(Credential.APIKEY)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        do {
            request.debug()
            
            let (data, _) = try await URLSession.shared.upload(for: request, from: jsonData)
            

            do {
                let decodedResponse = try decoder.decode(ProductListResponse.self, from: data)
                print("response")
                return decodedResponse
            } catch {
                print("Error decoding response: \(error)")
            }
        } catch {
            print("Invalid data")
        }
        return nil
    }
}


extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
            print("data======>>>",data)
        }
    }
}

//Used to decode data
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                    // Print the JSON data
//                    print(json)
//                } else {
//                    print("Error converting data to JSON")
//                }

