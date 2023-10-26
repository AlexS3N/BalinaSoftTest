import Foundation

struct GetModel: Decodable {
    let content: [Content]
    let page: Int
    let totalPages: Int
}

struct Content: Decodable {
    let id: Int
    let name: String
    let image: String?
}
