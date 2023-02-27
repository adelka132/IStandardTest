import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String] { get }
    var body: [String: String] { get }
    var queryItems: [String : String] { get }
}

extension Endpoint {
    var scheme: String {
        return "https"
    }

    var host: String {
        return "hr-challenge.interactivestandard.com"
    }

    var header: [String: String] { [:] }
    var body: [String: String] { [:] }
    var queryItems: [String : String] { [:] }
}
