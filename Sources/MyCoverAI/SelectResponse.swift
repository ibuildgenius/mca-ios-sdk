import Foundation
import AnyCodable

struct SelectResponse: Decodable {
    let responseCode: Int
    let responseText: String
    let data: [AnyDecodable]
}
