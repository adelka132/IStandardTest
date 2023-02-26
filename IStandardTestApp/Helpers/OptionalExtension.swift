import Foundation

public protocol _OptionalProtocol<Wrapped> {
    associatedtype Wrapped
    
    var description: String { get }
}

extension Optional: _OptionalProtocol {
    @_implements(_OptionalProtocol, description)
    public var omniform_description: String {
        guard let wrapped = self else { return "" }
        if let optional = wrapped as? any _OptionalProtocol {
            return optional.description
        } else {
            return String(describing: wrapped)
        }
    }
}

internal extension String {
    @usableFromInline
    init(optionallyDescribing value: some Any) {
        self = (value as? any _OptionalProtocol)?.description ?? String(describing: value)
    }
}
