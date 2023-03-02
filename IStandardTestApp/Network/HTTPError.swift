import Foundation

enum HTTPError: LocalizedError {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    case badRequest
    case internalServerError

    var errorDescription: String? {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        case .badRequest:
            return "Bad request"
        case .internalServerError:
            return "Internal Server Error"
        default:
            return "Unknown error"
        }
    }
}
