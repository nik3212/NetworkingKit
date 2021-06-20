import Alamofire
import Foundation

public protocol SessionProtocol: AnyObject {
    var queue: DispatchQueue { get }
    var underlyingSession: Alamofire.Session { get }
    var responseDecoder: DataDecoder { get }

    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func request<T: Requestable>(_ request: T) async throws -> T.Response
}
