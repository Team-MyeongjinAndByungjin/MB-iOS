import Foundation

struct CouponsResponseElement: Codable {
    let id: Int
    let name: String
    let from: String
    let imageURL, expiredAt, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, from
        case imageURL = "image_url"
        case expiredAt = "expired_at"
        case createdAt = "created_at"
    }
}

typealias CouponsResponse = [CouponsResponseElement]
