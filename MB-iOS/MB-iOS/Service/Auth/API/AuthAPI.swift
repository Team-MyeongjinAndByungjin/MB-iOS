import Foundation
import Moya

enum AuthAPI {
    case login(id: String, password: String)
    case signUp(id: String, password: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://192.168.1.135:8080/users")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/token"
        case .signUp:
            return ""
        }
    }

    var method: Moya.Method {
        return .post
    }

    var task: Moya.Task {
        switch self {
        case .login(let id, let password):
            return .requestParameters(
                parameters: [
                    "account_id": id,
                    "password": password
                ], encoding: JSONEncoding.default)
        case .signUp(let id, let password):
            return .requestParameters(
                parameters: [
                    "account_id": id,
                    "password": password
                ], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return Header.tokenIsEmpty.header()
    }
}
