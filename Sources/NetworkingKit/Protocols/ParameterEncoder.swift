import Foundation

/// The protocol describing a parameter encoding object.
public protocol ParameterEncoder {
    /// Encode parameters into request.
    func encode<Parameters: Encodable>(_ parameters: Parameters, into request: inout URLRequest) throws
}
