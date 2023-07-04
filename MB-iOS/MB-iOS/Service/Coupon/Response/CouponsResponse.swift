import Foundation

struct CouponsResponseElement: Codable {
    let id: Int
    let name: String
    let price: Int
    let imageURL, expiredAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, price
        case imageURL = "image_url"
        case expiredAt = "expired_at"
    }
}

typealias CouponsResponse = [CouponsResponseElement]
