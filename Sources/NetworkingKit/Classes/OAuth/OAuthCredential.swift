import Alamofire

public protocol OAuthCredential: AuthenticationCredential {
    var accessToken: String { get }
    var requiresRefresh: Bool { get }
}
