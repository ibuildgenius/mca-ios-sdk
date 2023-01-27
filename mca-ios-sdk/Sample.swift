//
//  Sample.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 26/01/2023.
//

import Foundation

class Sample: ObservableObject {
    let responseData: ProductListResponse
    
    init() {
        let url = Bundle.main.url(forResource: "sample/response", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        responseData = try! JSONDecoder().decode(ProductListResponse.self, from: data)
    }
}
