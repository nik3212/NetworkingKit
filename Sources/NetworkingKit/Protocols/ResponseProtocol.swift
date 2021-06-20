import Foundation

/// The protocol describing a response.
public protocol ResponseProtocol {
    associatedtype Success
    associatedtype Failure: Swift.Error
    
    /// A result type that contains a response of request.
    var result: Result<Success, Failure> { get }
}
