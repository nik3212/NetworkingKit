import Alamofire
import Foundation

open class Session: SessionProtocol {
    public required init(
        configuration: URLSessionConfiguration = .default,
        parameterEncoding: ParameterEncoding = .urlEncodedFormParameter,
        responseDecoder: DataDecoder = JSONDecoder()
    ) {
        self.parameterEncoding = parameterEncoding
        self.responseDecoder = responseDecoder
        underlyingSession = .init(
            configuration: configuration,
            rootQueue: queue
        )
    }

    open var queue = DispatchQueue(
        label: "\(String(reflecting: Session.self))",
        qos: .default
    )

    open private(set) var underlyingSession: Alamofire.Session
    open private(set) var responseDecoder: DataDecoder
    open private(set) var parameterEncoding: ParameterEncoding

    @discardableResult
    open func request<T: Requestable>(
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
                    )
                )
                request.underlyingRequest = alamofireRequest

                alamofireRequest
                    .validate(statusCode: 100 ..< 400)
                    .responseDecodable(
                        queue: self.queue,
                        decoder: self.responseDecoder,
                        completionHandler: {
                            completion(.init(
                                result: $0.result
                                    .mapError { $0.underlyingError ?? $0 },
                                response: $0.response
                            ))
                        }
                    )
            } catch {
                completion(.init(result: .failure(error)))
            }
        }

        return request
    }

    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    open func request<T: Requestable>(_ request: T) async throws -> T.Response {
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

    public static var shared: Session = .init()
}
