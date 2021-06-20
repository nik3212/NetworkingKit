import Alamofire
import Foundation

///
public extension ParameterEncoding {
    ///
    static var urlEncodedFormParameter: ParameterEncoding {
        .urlEncodedFormParameter()
    }
    
    /// Create a new instance of ``ParameterEncoding``
    ///
    /// - Parameters:
    ///   - encoder: An object that encodes instances into URL-encoded query strings.
    ///   - destination: Defines where the URL-encoded string should be set for each URLRequest.
    ///
    /// - Returns: A new `ParameterEncoding` instance.
    static func urlEncodedFormParameter(
        encoder: URLEncodedFormEncoder = URLEncodedFormEncoder(),
        destination: Alamofire.URLEncodedFormParameterEncoder.Destination = .methodDependent
    ) -> ParameterEncoding {
        self.init(encoder: URLEncodedFormParameterEncoder(encoder: encoder, destination: destination))
    }
}
