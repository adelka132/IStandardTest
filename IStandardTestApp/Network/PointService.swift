import Foundation

protocol PointServiceable {
    func getPoints(count: Int) async -> Result<GraphicData, HTTPError>
}

struct PointService: HTTPClient, PointServiceable {
    func getPoints(count: Int) async -> Result<GraphicData, HTTPError> {
        await sendRequest(endpoint: PointsEndpoint.points(count: count), responseModel: GraphicData.self)
    }
}
