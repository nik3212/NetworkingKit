import Alamofire
import Foundation

public protocol Requestable {
    associatedtype Parameters: Encodable
    associatedtype Response: Decodable

    typealias Headers = [String: String]

    var baseURL: URL { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var requiresAuthentification: Bool { get }

    var parameterEncoding: ParameterEncoding? { get }

    var httpMethod: URLRequest.HTTPMethod { get }
    var httpHeaders: Headers? { get }
}

public extension Requestable {
    var httpHeaders: Headers? {
        nil
    }

    var parametersEncoding: ParameterEncoding? {
        nil
    }
}

extension Requestable {
    func asURLRequest(baseURL: URL? = nil, parameterEncoding: ParameterEncoding) throws -> URLRequest {
        var request = URLRequest(
            url: URL(
                string: path,
                relativeTo: baseURL
            )!
        )

        request.httpMethod = httpMethod.rawValue

        if let headers = httpHeaders {
            request.headers = .init(headers)
        }

        try (self.parameterEncoding ?? parameterEncoding).encode(parameters, into: &request)

        return request
    }
}
