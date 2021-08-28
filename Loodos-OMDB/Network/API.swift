import Foundation
import Moya

enum API {
    case search(t: String)
    case detail(t: String)
}

extension API: TargetType {
    struct Constants {
        static let apiKey = "be143b55"
    }
    
    var baseURL: URL {
        guard let url = URL(string: "http://www.omdbapi.com/") else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .search:
            return ""
        case .detail:
            return ""
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .search(t: let title):
            return .requestParameters(parameters: ["apikey": API.Constants.apiKey, "s": title], encoding: URLEncoding.queryString)
        case .detail(t: let title):
            return .requestParameters(parameters: ["apikey": API.Constants.apiKey, "i": title], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
