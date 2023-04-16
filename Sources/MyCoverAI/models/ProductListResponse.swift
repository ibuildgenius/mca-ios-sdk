// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let productListResponse = try? JSONDecoder().decode(ProductListResponse.self, from: jsonData)

import Foundation
import AnyCodable

// MARK: - ProductListResponse
struct ProductListResponse : Decodable{
    var responseCode: Int
    var responseText: String
    var data: DataClass
}

// MARK: - DataClass
struct DataClass : Decodable {
    var businessDetails: BusinessDetails?
    var productDetails: [ProductDetail]
}

// MARK: - BusinessDetails
struct BusinessDetails: Decodable {
    var debit_wallet: Bool
    var id: String
    var trading_name: String
    var business_name: String
    var instance_id: String
    var payment_channels: [String]
}

// MARK: - ProductDetail
struct ProductDetail : Decodable{
    var id: String
    var name: String
    var key_benefits: AnyDecodable?
    var description: String
    var prefix: String
    var renewable: Bool
    var claimable: Bool
    var inspectable: Bool
    var certificateable: Bool
    var is_dynamic_pricing: Bool
    var price: String
    var distributor_commission_percentage: String
    var mca_commission_percentage: String
    var cover_period: String?
    var active: Bool
    var how_it_works: String?
    var how_to_claim: String?
    var product_category_id: String
    var provider_id: String
    var form_fields: [FormFieldElement]
}

// MARK: - FormFieldElement
struct FormFieldElement: Decodable, Identifiable {
    var id: String
    var app_mode: String
    var description: String
    var name: String
    var label: String
    var position: Int
    var full_description: String
    var data_type: String
    var input_type: String
    var show_first: Bool
    var required: Bool
    var data_source: String
    var data_url: String?
    var depends_on: String?
    var min: Int?
    var max: Int?
    var min_max_constraint: String
    var form_field_id: String
    var product_id: String
    var form_field: FormFieldFormField
}


struct DataType {
    static let array = "array"
    static let boolean = "boolen"
    static let number = "number"
    static let string = "string"
}

// MARK: - FormFieldFormField
struct FormFieldFormField : Decodable{
    var id: String
    var name: String?
    var label: String?
}


struct InputType: Decodable {
    static let date = "date"
    static let email = "email"
    static let file = "file"
    static let hidden = "hidden"
    static let number = "number"
    static let phone = "phone"
    static let text = "text"
}




extension [FormFieldElement] {
    func piorityForms() -> [FormFieldElement] {
        return self.sorted{ $0.position < $1.position }
    }
    
    func showFirstFields() -> [FormFieldElement] {
        return piorityForms().filter{ $0.show_first }
    }
    
    func afterPaymentFields() -> [FormFieldElement] {
        return piorityForms().filter{ !$0.show_first }
    }
    
}
