//
//  ProductListResponse.swift
//  mca-ios-sdk
//
//

import Foundation

//
//   let productPurchaseResponse = try? JSONDecoder().decode(ProductPurchaseResponse.self, from: jsonData)

import Foundation
import AnyCodable

// MARK: - ProductPurchaseResponse
struct ProductListResponse: Decodable {
    let responseCode: Int
    let responseText: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Decodable {
    var businessDetails: BusinessDetails? = nil
    var productDetails: [ProductDetail] = []
}

// MARK: - BusinessDetails
struct BusinessDetails: Decodable {
    let debitWallet: Bool
    let logo, colorTheme: JSONNull?
    let dataValues, previousDataValues: DataValues?
    let uniqno: Int?
    let changed: Changed?
    let options: Options?
    let isNewRecord: Bool?
    let instanceID: String?
    let paymentChannels: [String]

    enum CodingKeys: String, CodingKey {
        case debitWallet = "debit_wallet"
        case logo
        case colorTheme = "color_theme"
        case dataValues
        case previousDataValues = "_previousDataValues"
        case uniqno
        case changed = "_changed"
        case options = "_options"
        case isNewRecord
        case instanceID = "instance_id"
        case paymentChannels = "payment_channels"
    }
}

// MARK: - Changed
struct Changed: Decodable {
}

// MARK: - DataValues
struct DataValues: Decodable {
    let id, tradingName, businessName: String

    enum CodingKeys: String, CodingKey {
        case id
        case tradingName = "trading_name"
        case businessName = "business_name"
    }
}

// MARK: - Options
struct Options: Decodable {
    let isNewRecord: Bool
    let schema: JSONNull?
    let schemaDelimiter: String
    let raw: Bool
    let attributes: [String]

    enum CodingKeys: String, CodingKey {
        case isNewRecord
        case schema = "_schema"
        case schemaDelimiter = "_schemaDelimiter"
        case raw, attributes
    }
}

// MARK: - ProductDetail
struct ProductDetail: Decodable {
    let id: String
    let isLive: Bool
    let name: String
    let keyBenefits: AnyDecodable?
    let fullBenefits: FullBenefits
    let description: String
    let meta: Meta
    let productDetailPrefix, routeName: String
    let renewable, claimable, inspectable, certificateable: Bool
    let isDynamicPricing: Bool
    let price, distributorCommissionPercentage, mcaCommissionPercentage: String
    let coverPeriod: String?
    let active: Bool
    let howItWorks, howToClaim: String?
    let document: JSONNull?
    let createdAt, updatedAt: String
    let deletedAt: JSONNull?
    let productCategoryID, providerID: String
    let formFields: [FormFieldElement]

    enum CodingKeys: String, CodingKey {
        case id
        case isLive = "is_live"
        case name
        case keyBenefits = "key_benefits"
        case fullBenefits = "full_benefits"
        case description, meta
        case productDetailPrefix = "prefix"
        case routeName = "route_name"
        case renewable, claimable, inspectable, certificateable
        case isDynamicPricing = "is_dynamic_pricing"
        case price
        case distributorCommissionPercentage = "distributor_commission_percentage"
        case mcaCommissionPercentage = "mca_commission_percentage"
        case coverPeriod = "cover_period"
        case active
        case howItWorks = "how_it_works"
        case howToClaim = "how_to_claim"
        case document
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case productCategoryID = "product_category_id"
        case providerID = "provider_id"
        case formFields = "form_fields"
    }
}

// MARK: - FormFieldElement
struct FormFieldElement: Decodable, Identifiable {
    let id: String
    let isLive: Bool
    let description, name, label: String
    let position: Int
    let fullDescription: String
    let dataType: DataType
    let inputType: InputType
    let showFirst, formFieldRequired: Bool
    let errorMsg, dataSource: String
    let dataURL, dependsOn: String?
    let meta: JSONNull?
    let min, max: Int?
    let minMaxConstraint: MinMaxConstraint
    let createdAt, updatedAt: String
    let deletedAt: JSONNull?
    let formFieldID, productID: String
    let formField: FormFieldFormField

    enum CodingKeys: String, CodingKey {
        case id
        case isLive = "is_live"
        case description, name, label, position
        case fullDescription = "full_description"
        case dataType = "data_type"
        case inputType = "input_type"
        case showFirst = "show_first"
        case formFieldRequired = "required"
        case errorMsg = "error_msg"
        case dataSource = "data_source"
        case dataURL = "data_url"
        case dependsOn = "depends_on"
        case meta, min, max
        case minMaxConstraint = "min_max_constraint"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case formFieldID = "form_field_id"
        case productID = "product_id"
        case formField = "form_field"
    }
}

enum DataType: String, Decodable {
    case array = "array"
    case boolean = "boolean"
    case number = "number"
    case string = "string"
}

// MARK: - FormFieldFormField
struct FormFieldFormField: Decodable {
    let id: String
    let name: String?
    let label: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, label
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

enum AtedAt: String, Decodable {
    case the20220728T181553581Z = "2022-07-28T18:15:53.581Z"
    case the20220728T181553596Z = "2022-07-28T18:15:53.596Z"
}

enum Label: String, Decodable {
    case inputFormField = "Input form field"
    case selectFormField = "Select form field"
}

enum Name: String, Decodable {
    case input = "Input"
    case select = "Select"
}

enum InputType: String, Decodable {
    case date = "date"
    case email = "email"
    case file = "file"
    case hidden = "hidden"
    case number = "number"
    case phone = "phone"
    case text = "text"
}

enum MinMaxConstraint: String, Decodable {
    case length = "length"
    case value = "value"
}

enum FullBenefits: Decodable {
    case fullBenefitArray([FullBenefit])
    case string(String)
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([FullBenefit].self) {
            self = .fullBenefitArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if container.decodeNil() {
            self = .null
            return
        }
        throw DecodingError.typeMismatch(FullBenefits.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for FullBenefits"))
    }
}

// MARK: - FullBenefit
struct FullBenefit: Decodable {
    let name, description: String
}

// MARK: - Meta
struct Meta: Decodable {
    let productID, subClassID, productName, sectionType: String?
    let subClassName, truckPrice, privatePrice, commercialPrice: String?
    let planCode, policyType, plusPrice, basicPrice: String?
    let classicPrice, silverPrice, noWaitTimePrice: String?

    enum CodingKeys: String, CodingKey {
        case productID = "productId"
        case subClassID = "subClassId"
        case productName, sectionType, subClassName
        case truckPrice = "truck_price"
        case privatePrice = "private_price"
        case commercialPrice = "commercial_price"
        case planCode = "plan_code"
        case policyType = "policy_type"
        case plusPrice = "plus_price"
        case basicPrice = "basic_price"
        case classicPrice = "classic_price"
        case silverPrice = "silver_price"
        case noWaitTimePrice = "no_wait_time_price"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Decodable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

