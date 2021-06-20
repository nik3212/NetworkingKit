import Alamofire
import Foundation

public protocol RequestProtocol {
    associatedtype Requestable: NetworkingKit.Requestable

    var requestable: Requestable { get }
    var underlyingRequest: Alamofire.DataRequest? { get }
}

public extension RequestProtocol {
    func cancel() {
        underlyingRequest?.cancel()
    }
}
