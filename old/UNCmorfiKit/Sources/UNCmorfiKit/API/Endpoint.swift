//
// Copyright © 2019 George Alegre. All rights reserved.
//

import Foundation

public struct Endpoint<A: Decodable> {
    let path: String
    let queryParameters: [URLQueryItem]

    init(path: String, queryParameters: [URLQueryItem] = []) {
        self.path = path
        self.queryParameters = queryParameters
    }

    var urlRequest: URLRequest {
        let baseURL = URL(string: "https://uncmorfi.alegre.dev")!

        var components = URLComponents(string: baseURL.appendingPathComponent(path).absoluteString)!
        components.queryItems = queryParameters

        return URLRequest(url: components.url!)
    }
}

public extension Endpoint {
    static func users(from codes: [String]) -> Endpoint<[User]> {
        let queryParameters: [URLQueryItem]
        if codes.isEmpty {
            queryParameters = []
        } else {
            queryParameters = [URLQueryItem(name: "codes", value: codes.joined(separator: ","))]
        }

        return Endpoint<[User]>(path: "/users", queryParameters: queryParameters)
    }

    static var menu: Endpoint<Menu> { Endpoint<Menu>(path: "/menu") }

    static var servings: Endpoint<Servings> { Endpoint<Servings>(path: "/servings") }
}

public enum APIError: Error {
    case noData
    case decodingFailed
    case wrongStatusCode
}

public extension URLSession {
    func load<A>(_ endpoint: Endpoint<A>, completion: @escaping (Result<A, APIError>) -> Void) {
        dataTask(with: endpoint.urlRequest) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            let decodedData: A
            do {
                decodedData = try decoder.decode(A.self, from: data)
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingFailed))
                }
                return
            }

            DispatchQueue.main.async {
                completion(.success(decodedData))
            }
        }.resume()
    }
}

#if canImport(Combine)
import Combine

@available(iOS 13.0, *)
public extension URLSession {
    func load<A>(_ endpoint: Endpoint<A>) -> AnyPublisher<A, APIError> {
        dataTaskPublisher(for: endpoint.urlRequest)
            .tryMap { data, response in
                guard (200...299).contains((response as! HTTPURLResponse).statusCode) else {
                    throw APIError.wrongStatusCode
                }

                return data
            }
            .decode(type: A.self, decoder: JSONDecoder())
            .mapError { error in
                APIError.decodingFailed
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
#endif
