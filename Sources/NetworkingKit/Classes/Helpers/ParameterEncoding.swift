import Foundation

struct CustomParameterEncoder: ParameterEncoder {
    func encode<Parameters>(_ parameters: Parameters, into request: inout URLRequest) throws where Parameters : Encodable {
        try _encoder(parameters, &request)
    }

    fileprivate var _encoder: (Encodable?, inout URLRequest) throws -> Void
}

public struct ParameterEncoding {
    private var _encoder: ParameterEncoder

    public static func custom(
        _ encoder: @escaping (Encodable?, inout URLRequest) throws -> Void
    ) -> ParameterEncoding {
        .init(encoder: CustomParameterEncoder(_encoder: encoder))
    }

    public init(encoder: ParameterEncoder) {
        self._encoder = encoder
    }

    public func encode<Parameters: Encodable>(_ parameters: Parameters?, into request: inout URLRequest) throws {
        try _encoder.encode(parameters, into: &request)
    }
}
