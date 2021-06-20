import Alamofire
import Foundation

extension OAuthSession: Alamofire.Authenticator {
    public func apply(_ credential: Authenticator.Credential, to urlRequest: inout URLRequest) {
        authentificator.apply(credential, to: &urlRequest)
    }
    
    public func refresh(_ credential: Authenticator.Credential, for session: Alamofire.Session, completion: @escaping (Result<Authenticator.Credential, Error>) -> Void) {
        authentificator.refresh(credential, for: session, completion: completion)
    }
    
    public func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: Error) -> Bool {
        authentificator.didRequest(urlRequest, with: response, failDueToAuthenticationError: error)
    }
    
    public func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: Authenticator.Credential) -> Bool {
        authentificator.isRequest(urlRequest, authenticatedWith: credential)
    }
    
    public typealias Credential = Authenticator.Credential
}
