

import Foundation
import Moya

protocol Networkable {
    var provider: MoyaProvider<API> { get }

    func fetchSearchResult(title: String, completion: @escaping (Swift.Result<Movie, Error>) -> ())
    func fetchDetailResult(imdbId: String, completion: @escaping (Swift.Result<MovieDetail, Error>) -> ())
}

class NetworkManager: Networkable {
    var provider = MoyaProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    func fetchSearchResult(title: String, completion: @escaping (Swift.Result<Movie, Error>) -> ()) {
        request(target: API.search(t: title), completion: completion)
    }
    func fetchDetailResult(imdbId: String, completion: @escaping (Swift.Result<MovieDetail, Error>) -> ()) {
        request(target: API.detail(t: imdbId), completion: completion)
    }
}

private extension NetworkManager {
    private func request<T: Decodable>(target: API, completion: @escaping (Swift.Result<T, Error>) -> ()) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
