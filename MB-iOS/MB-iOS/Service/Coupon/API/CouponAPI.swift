import Foundation
import Moya

enum CouponAPI {
    case getCoupons
    case saveCoupon(imageURL: String, from: String, name: String, expiredAt: String)
    case deleteCoupon(couponID: Int)
    case giveCouponToUser(couponID: Int, receiveUserID: String)
}

extension CouponAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://3.38.34.230:8080/coupons")!
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
        case .giveCouponToUser:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .saveCoupon(let imageURL, let from, let name, let expiredAt):
            return .requestParameters(
                parameters: [
                    "name": name,
                    "from": from,
                    "image_url": imageURL,
                    "expired_at": expiredAt
                ],
                encoding: JSONEncoding.default)
        case .giveCouponToUser(let couponID, let receiveUserID):
            return .requestParameters(
                parameters: [
                    "coupon-id": couponID,
                    "account-id": receiveUserID
                ],
                encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return Header.accessToken.header()
    }
}
