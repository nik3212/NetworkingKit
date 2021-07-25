import Foundation

public enum NetworkingKitError: Error {
    case encodableMapping
    case parameterEncoding(Error)
}
