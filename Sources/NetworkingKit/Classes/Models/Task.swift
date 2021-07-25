import Alamofire
import Foundation

public enum Task {
    case requestPlain
    case requestData(Data)
    case requestJSONEncodable(Encodable)
    case requestCustomJSONEncodable(Encodable, encoder: JSONEncoder)
    case requestParameters(parameters: [String: Any], encoding: Alamofire.ParameterEncoding)
    case requestCompositeData(bodyData: Data, urlParameters: [String: Any])
    case requestCompositeParameters(bodyParameters: [String: Any], bodyEncoding: Alamofire.ParameterEncoding, urlParameters: [String: Any])
}
