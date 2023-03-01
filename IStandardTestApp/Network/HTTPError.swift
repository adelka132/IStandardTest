import Foundation

enum HTTPError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    case badRequest
    case internalServerError

    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        case .badRequest:
            return "не верное кол-во точек"
        case .internalServerError:
            return "Очень внезапная (и страшная) ошибка"
        default:
            return "Unknown error"
        }
    }
}

/*
 1) Заменить кастом на дефолт Error
 2) В нужном мне сервисе обрабатываю эту ошбику как мне надо
 */
