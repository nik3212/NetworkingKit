import Foundation

public extension URLRequest {
    /// Type representing HTTP methods. Raw `String` value is stored and compared case-sensitively, so
    /// `HTTPMethod.get != HTTPMethod(rawValue: "get")`.
    ///
    /// See https://tools.ietf.org/html/rfc7231#section-4.3
    struct HTTPMethod: RawRepresentable, Equatable, Hashable {
        // MARK: Lifecycle
        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        // MARK: Public
        /// `CONNECT` method.
        public static let connect = HTTPMethod(rawValue: "CONNECT")
        /// `DELETE` method.
        public static let delete = HTTPMethod(rawValue: "DELETE")
        /// `GET` method.
        public static let get = HTTPMethod(rawValue: "GET")
        /// `HEAD` method.
        public static let head = HTTPMethod(rawValue: "HEAD")
        /// `OPTIONS` method.
        public static let options = HTTPMethod(rawValue: "OPTIONS")
        /// `PATCH` method.
        public static let patch = HTTPMethod(rawValue: "PATCH")
        /// `POST` method.
        public static let post = HTTPMethod(rawValue: "POST")
        /// `PUT` method.
        public static let put = HTTPMethod(rawValue: "PUT")
        /// `TRACE` method.
        public static let trace = HTTPMethod(rawValue: "TRACE")

        public let rawValue: String
    }
}
