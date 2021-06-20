import Alamofire
import Foundation

public class Request<Requstable: Requestable>: RequestProtocol {
    init(requestable: Requstable) {
        self.requestable = requestable
    }

    public var requestable: Requstable
    public internal(set) var underlyingRequest: Alamofire.DataRequest?
}
