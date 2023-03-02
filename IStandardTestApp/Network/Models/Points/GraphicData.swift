import Foundation

// MARK: - GraphicData
struct GraphicData: Codable {
    let points: [Point]
}

// MARK: - Point
struct Point: Codable {
    let x, y: Double

    static func < (lhs: Point, rhs: Point) -> Bool { lhs.x < rhs.x }
}
