import Alamofire
import Foundation

/// The protocol describing a request.
public protocol RequestProtocol {
    associatedtype Requestable: NetworkingKit.TargetType
    
    /// A ``Requestable`` value that contains the initial request.
    var requestable: Requestable { get }
    /// An `Alamofire.DataRequest` value that contains the Alamofire's request.
    var underlyingRequest: Alamofire.DataRequest? { get }
}

public extension RequestProtocol {
    /// Cancel request.
    func cancel() {
        underlyingRequest?.cancel()
    }
}
