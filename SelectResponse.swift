import Foundation

struct SelectResponse: Codable {
    let responseCode: Int
    let responseText: String
    let data: [String]
}
