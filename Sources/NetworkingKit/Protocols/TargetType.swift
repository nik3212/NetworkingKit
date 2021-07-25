import Alamofire
import Foundation

/// The protocol representing a requestable object.
public protocol TargetType {
    typealias Headers = [String: String]
    
    /// Base url to the resource.
    var baseURL: URL { get }
    /// Path to the resource.
    var path: String { get }
    /// A dictionary that contains the parameters that will be encoded into request.
    var task: Task { get }
    /// A Boolean value indicating whether the requires authentication.
    var requiresAuthentification: Bool { get }
    
    /// Parameter encoding strategy.
    var parameterEncoding: ParameterEncoding? { get }
    
    /// Type representing HTTP methods.
    var httpMethod: URLRequest.HTTPMethod { get }
    /// HTTP headers.
    var httpHeaders: Headers? { get }
}

public extension TargetType {
    var httpHeaders: Headers? {
        nil
    }

    var parameterEncoding: ParameterEncoding? {
        nil
    }
}

extension TargetType {
    /// Create an `URLRequest`.
    ///
    /// - Parameters:
    ///   - baseURL: Base url to the resource.
    ///   - parameterEncoding: Parameter encoding strategy.
    ///
    /// - Returns: Configured instance of `URLRequest`.
    func asURLRequest(baseURL: URL? = nil) throws -> URLRequest {
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

        switch task {
        case .requestPlain:
            return request
        case let .requestData(data):
            request.httpBody = data
            return request
        case let .requestJSONEncodable(encodable):
            return try request.encoded(encodable: encodable)
        case let .requestCustomJSONEncodable(encodable, encoder):
            return try request.encoded(encodable: encodable, encoder: encoder)
        case let .requestParameters(parameters, parameterEncoding):
            return try request.encoded(parameters: parameters, parameterEncoding: parameterEncoding)
        case let .requestCompositeData(bodyData, urlParameters):
            request.httpBody = bodyData
            let parameterEncoding = URLEncoding(destination: .queryString)
            return try request.encoded(parameters: urlParameters, parameterEncoding: parameterEncoding)
        case let .requestCompositeParameters(bodyParameters, bodyEncoding, urlParameters):
            let bodyfulRequest = try request.encoded(parameters: bodyParameters, parameterEncoding: bodyEncoding)
            let urlEncoding = URLEncoding(destination: .queryString)
            return try bodyfulRequest.encoded(parameters: urlParameters, parameterEncoding: urlEncoding)
        }
    }
}
