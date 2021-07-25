import Foundation

public enum MultiTarget: TargetType {
    public var httpHeaders: Headers? {
        target.httpHeaders
    }
    
    public var baseURL: URL {
        target.baseURL
    }
    
    public var path: String {
        target.path
    }
    
    public var task: Task {
        target.task
    }
    
    public var requiresAuthentification: Bool {
        target.requiresAuthentification
    }
    
    public var httpMethod: URLRequest.HTTPMethod {
        target.httpMethod
    }
    
    /// The embedded `TargetType`.
    case target(TargetType)

    /// Initializes a `MultiTarget`.
    public init(_ target: TargetType) {
        self = MultiTarget.target(target)
    }

    public var target: TargetType {
        switch self {
        case .target(let target): return target
        }
    }
}
