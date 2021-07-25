import Combine

extension Session {
    public typealias RequestResult<T: Decodable> = AnyPublisher<T, Error>

    @discardableResult
    open func request<T: Decodable>(_ type: T.Type, _ request: Target, credential: Credential? = nil) -> RequestResult<T> {
        var _request: Request<Target>?

        return Future { promise in
            _request = self.request(type, target: request, credential: credential) { response in
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
