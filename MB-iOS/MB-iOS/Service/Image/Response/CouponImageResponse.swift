import Foundation

struct CouponImageResponse: Decodable {
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
    }
}
