import Alamofire
import Foundation

public protocol OAuthAuthentificator {
    associatedtype Credential: OAuthCredential

    func apply(_ credential: Credential, to urlRequest: inout URLRequest)
    func refresh(_ credential: Credential, for session: Alamofire.Session, completion: @escaping (Result<Credential, Error>) -> Void)
    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: Error) -> Bool
    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: Credential) -> Bool
}

public extension OAuthAuthentificator {
    func apply(_ credential: Credential, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
    }

    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: Error) -> Bool {
        response.statusCode == 401
    }

    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: Credential) -> Bool {
        urlRequest.headers.contains(.authorization(bearerToken: credential.accessToken))
    }
}
