import Alamofire
import Foundation

/// The protocol representing a requestable object.
public protocol Requestable {
    associatedtype Parameters: Encodable
    associatedtype Response: Decodable

    typealias Headers = [String: String]
    
    /// Base url to the resource.
    var baseURL: URL { get }
    /// Path to the resource.
    var path: String { get }
    /// A dictionary that contains the parameters that will be encoded into request.
    var parameters: Parameters? { get }
    /// A Boolean value indicating whether the requires authentication.
    var requiresAuthentification: Bool { get }
    
    /// Parameter encoding strategy.
    var parameterEncoding: ParameterEncoding? { get }
    
    /// Type representing HTTP methods.
    var httpMethod: URLRequest.HTTPMethod { get }
    /// HTTP headers.
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
    /// Create an `URLRequest`.
    ///
    /// - Parameters:
    ///   - baseURL: Base url to the resource.
    ///   - parameterEncoding: Parameter encoding strategy.
    ///
    /// - Returns: Configured instance of `URLRequest`.
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
