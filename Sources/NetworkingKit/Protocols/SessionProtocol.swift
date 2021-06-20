import Alamofire
import Foundation

/// Protocol that represents a base session object.
public protocol SessionProtocol: AnyObject {
    /// The queue on which the request's completion handler is dispatched.
    var queue: DispatchQueue { get }
    /// `Session` creates and manages Alamofire’s Request types during their lifetimes.
    /// It also provides common functionality for all Requests, including queuing,
    /// interception, trust management, redirect handling, and response cache handling.
    var underlyingSession: Alamofire.Session { get }
    /// Any type which can decode Data into a Decodable type.
    var responseDecoder: DataDecoder { get }
}
