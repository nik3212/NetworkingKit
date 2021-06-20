import Alamofire
import Foundation

open class OAuthSession<Authenticator: OAuthAuthentificator>: Session {
    public required init(
        configuration: URLSessionConfiguration = .default,
        baseURL: URL? = nil,
        responseDecoder: DataDecoder = JSONDecoder(),
        parameterEncoding: ParameterEncoding = .urlEncodedFormParameter,
        authentificator: Authenticator,
        credential: Credential? = nil
    ) {
        self.authentificator = authentificator

        super.init(
            configuration: configuration,
            parameterEncoding: parameterEncoding,
            responseDecoder: responseDecoder
        )

        authentificatorInterceptor.credential = credential
    }

    @available(*, unavailable)
    public required init(
        configuration: URLSessionConfiguration = .default,
        parameterEncoding: ParameterEncoding = .urlEncodedFormParameter,
        responseDecoder: DataDecoder = JSONDecoder()
    ) {
        fatalError("init(configuration:parameterEncoding:responseDecoder:) has not been implemented")
    }

    open private(set) var authentificator: Authenticator
    open private(set) lazy var authentificatorInterceptor = AuthenticationInterceptor(
        authenticator: self,
        credential: nil
    )

    @discardableResult
    override open func request<T: Requestable>(
        _ request: T,
        completion: @escaping (Response<T.Response, Error>) -> Void
    ) -> Request<T> {
        let request = Request(requestable: request)

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
    open override func request<T: Requestable>(_ request: T) async throws -> T.Response {
        try await withCheckedThrowingContinuation({ continuation in
            self.request(request) { response in
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
