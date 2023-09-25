import Foundation

struct GetModel: Decodable {
    let content: [Content]
}

struct Content: Decodable {
    let id: Int
    let name: String
    let image: String?
}
