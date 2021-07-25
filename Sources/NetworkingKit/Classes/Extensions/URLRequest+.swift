import Alamofire
import Foundation

internal extension URLRequest {
    @discardableResult
    mutating func encoded(encodable: Encodable, encoder: JSONEncoder = JSONEncoder()) throws -> URLRequest {
        do {
            let encodable = AnyEncodable(encodable)
            httpBody = try encoder.encode(encodable)

            let contentTypeHeaderName = "Content-Type"
            if value(forHTTPHeaderField: contentTypeHeaderName) == nil {
                setValue("application/json", forHTTPHeaderField: contentTypeHeaderName)
            }

            return self
        } catch {
            throw NetworkingKitError.encodableMapping
        }
    }

    @discardableResult
    func encoded(parameters: [String: Any], parameterEncoding: Alamofire.ParameterEncoding) throws -> URLRequest {
        do {
            return try parameterEncoding.encode(self, with: parameters)
        } catch {
            throw NetworkingKitError.parameterEncoding(error)
        }
    }
}
