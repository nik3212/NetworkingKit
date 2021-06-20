import Foundation

public protocol ParameterEncoder {
    func encode<Parameters: Encodable>(_ parameters: Parameters, into request: inout URLRequest) throws
}
