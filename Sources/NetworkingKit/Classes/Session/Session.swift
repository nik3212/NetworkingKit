import Alamofire
import Foundation

open class Session<Authenticator: OAuthAuthentificator>: SessionProtocol {
    /// Create a new instance of `OAuthSession`.
    ///
    /// - Parameters:
    ///   - configuration: A configuration object that defines behavior and policies for a URL session.
    ///   - baseURL: The base url to resource.
    ///   - responseDecoder: Any type which can decode Data into a Decodable type.
    ///   - parameterEncoding: Parameter encoding strategy.
    ///   - authentificator: Types adopting the `Authenticator` protocol can be used to authenticate `URLRequest`s with an
    /// `AuthenticationCredential` as well as refresh the `AuthenticationCredential` when required.
    ///   - credential: The type of credential associated with the `Authenticator` instance.
    public required init(
        configuration: URLSessionConfiguration = .default,
        baseURL: URL? = nil,
        responseDecoder: DataDecoder = JSONDecoder(),
        parameterEncoding: ParameterEncoding = .urlEncodedFormParameter,
        authentificator: Authenticator,
        credential: Credential? = nil
    ) {
        self.authentificator = authentificator

        self.parameterEncoding = parameterEncoding
        self.responseDecoder = responseDecoder
        underlyingSession = .init(
            configuration: configuration,
            rootQueue: queue
        )

        authentificatorInterceptor.credential = credential
    }

    open var queue = DispatchQueue(
        label: "\(String(reflecting: Session.self))",
        qos: .default
    )

    @available(*, unavailable)
    public required init(
        configuration: URLSessionConfiguration = .default,
        parameterEncoding: ParameterEncoding = .urlEncodedFormParameter,
        responseDecoder: DataDecoder = JSONDecoder()
    ) {
        fatalError("init(configuration:parameterEncoding:responseDecoder:) has not been implemented")
    }

    open private(set) var underlyingSession: Alamofire.Session
    open private(set) var responseDecoder: DataDecoder
    open private(set) var parameterEncoding: ParameterEncoding

    open private(set) var authentificator: Authenticator
    open private(set) lazy var authentificatorInterceptor = AuthenticationInterceptor(
        authenticator: self,
        credential: nil
    )

    @discardableResult
    open func request<T: Requestable>(
        _ request: T,
        credential: Credential? = nil,
        completion: @escaping (Response<T.Response, Error>) -> Void
    ) -> Request<T> {
        let request = Request(requestable: request)

        if let credential = credential {
            authentificatorInterceptor.credential = credential
        }

        queue.async {
            do {
                let alamofireRequest = try self.underlyingSession.request(
                    request.requestable.asURLRequest(
                        baseURL: request.requestable.baseURL,
                        parameterEncoding: self.parameterEncoding
                    ),
                    interceptor: request.requestable.requiresAuthentification ? self.authentificatorInterceptor : nil
                )
                request.underlyingRequest = alamofireRequest

                alamofireRequest
                    .validate(statusCode: 100 ..< 400)
                    .responseDecodable(
                        queue: self.queue,
                        decoder: self.responseDecoder) {
                        completion(.init(
                            result: $0.result
                                .mapError { $0.underlyingError ?? $0 },
                            response: $0.response
                        ))
                    }
            } catch {
                completion(.init(result: .failure(error)))
            }
        }

        return request
    }

    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    open func request<T: Requestable>(_ request: T, credential: Credential? = nil) async throws -> T.Response {
        try await withCheckedThrowingContinuation({ continuation in
            self.request(request, credential: credential) { response in
                switch response.result {
                case let .success(value):
                    continuation.resume(returning: value)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        })
    }
}
