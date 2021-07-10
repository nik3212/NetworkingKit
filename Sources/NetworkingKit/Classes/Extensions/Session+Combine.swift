import Combine

extension Session {
    public typealias RequestResult<T: Requestable> = AnyPublisher<T.Response, Error>

    @discardableResult
    open func request<T: Requestable>(_ request: T, credential: Credential? = nil) -> RequestResult<T> {
        var _request: Request<T>?

        return Future { promise in
            _request = self.request(request, credential: credential) { response in
                switch response.result {
                case let .success(data):
                    promise(.success(data))
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }
        .handleEvents(
            receiveSubscription: nil,
            receiveOutput: nil,
            receiveCompletion: nil,
            receiveCancel: {
                _request?.cancel()
            },
            receiveRequest: nil
        )
        .eraseToAnyPublisher()
    }
}
