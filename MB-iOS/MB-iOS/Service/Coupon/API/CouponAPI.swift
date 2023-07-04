import Foundation
import Moya

enum CouponAPI {
    case getCoupons
    case saveCoupon(imageURL: String, price: Int, name: String, expiredAt: String)
    case deleteCoupon(couponID: Int)
}

extension CouponAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://192.168.1.135:8080/coupons")!
    }
    
    var path: String {
        switch self {
        case .deleteCoupon(let couponID):
            return "\(couponID)"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCoupons:
            return .get
        case .saveCoupon:
            return .post
        case .deleteCoupon:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .saveCoupon(let imageURL, let price, let name, let expiredAt):
            return .requestParameters(
                parameters: [
                    "name": name,
                    "price": price,
                    "image_url": imageURL,
                    "expired_at": expiredAt
                ],
                encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return Header.accessToken.header()
    }
}
