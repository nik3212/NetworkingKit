import Alamofire
import Foundation

extension URLEncodedFormParameterEncoder: ParameterEncoder {
    public func encode<Parameters: Encodable>(_ parameters: Parameters, into request: inout URLRequest) throws {
        request = try encode(parameters, into: request)
    }
}
