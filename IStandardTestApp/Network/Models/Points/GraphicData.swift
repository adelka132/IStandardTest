import Foundation

// MARK: - GraphicData
struct GraphicData: Codable {
    let points: [Point]
}

// MARK: - Point
struct Point: Codable, Hashable {
    let x: Double
    let y: Double
}
