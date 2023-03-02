import Foundation

protocol PointServiceable {
    func getPoints(count: Int) async -> Result<GraphicData, PointsError>
}

struct PointService: PointServiceable {

    private let httpClient: HTTPClient

    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    func getPoints(count: Int) async -> Result<GraphicData, PointsError> {
        let result = await httpClient.sendRequest(endpoint: PointsEndpoint.points(count: count), responseModel: GraphicData.self)
        let newResult = result.mapError { error in
            switch error {
            case .badRequest:
                return PointsError.badRequest
            case .internalServerError:
                return PointsError.internalServerError
            default:
                return PointsError.unknown(error.localizedDescription)
            }
        }
        return newResult
    }
}
