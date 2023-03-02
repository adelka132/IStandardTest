import Foundation

enum PointsEndpoint {
    case points(count: Int)
}

extension PointsEndpoint: Endpoint {
    var path: String {
        switch self {
        case .points(_):
            return "/api/test/points"
        }
    }
    
    var method: HTTPMethod { .get }
    
    var queryItems: [String : String] {
        switch self {
        case .points(let count):
            return ["count": "\(count)"]
        }
    }
}

// MARK: - ExchangeRates
struct GraphicData: Codable {
    let points: [Point]
}

// MARK: - Point

struct Point: Codable {
    let x, y: Double

    static func < (lhs: Point, rhs: Point) -> Bool { lhs.x < rhs.x }
}
