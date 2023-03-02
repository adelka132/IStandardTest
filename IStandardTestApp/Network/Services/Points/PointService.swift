import Foundation

protocol PointServiceable {
    //заменили кастом еррор на дефолт
    func getPoints(count: Int) async -> Result<GraphicData, HTTPError>
}

struct PointService: HTTPClient, PointServiceable {
    func getPoints(count: Int) async -> Result<GraphicData, HTTPError> {
        await sendRequest(endpoint: PointsEndpoint.points(count: count),
                          responseModel: GraphicData.self)
    }
}
/*
 Cannot convert return expression of type 'Result<GraphicData, String>' to return type 'Result<GraphicData, any Error>'
 
 пробуем ебануть кастомную ошибку на разные сервисы
 
 let maptResult = result.mapError { error in
     switch error {
     case .badRequest:
         return "не верное кол-во точек"
     case .internalServerError:
         return "Очень внезапная (и страшная) ошибка"
     default:
         return "QUAVO?"
     }
 }
 */
