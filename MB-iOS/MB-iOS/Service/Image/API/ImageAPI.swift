import Foundation
import Moya

enum ImageAPI {
    case getImageURL(data: Data)
}

extension ImageAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://3.38.34.230:8080/images")!
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
        case .getImageURL(let data):
            return .requestData(data)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "multipart/form-data"]
    }
}
