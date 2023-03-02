import Foundation
import Charts

protocol GraphicPresenterProtocol {
    var numberOfRows: Int { get }
    var points: [Point] { get }
    func viewDidLoad()
    func getDataForGraphic() -> LineChartData
}

final class GraphicPresenter {

    weak var view: GraphicViewProtocol?
    let points: [Point]

    init(view: GraphicViewProtocol?, points: [Point]) {
        self.view = view
        self.points = points.sorted(by: { $0.x < $1.x })
    }
}

extension GraphicPresenter: GraphicPresenterProtocol {

    var numberOfRows: Int { points.count }
    
    func viewDidLoad() {
        view?.updateTableView()
        view?.updateGraphic()
    }

    func getDataForGraphic() -> LineChartData {
        let points = points.compactMap(ChartDataEntry.init)
        let dataSet = LineChartDataSet(entries: points)
        dataSet.mode = .cubicBezier
        return LineChartData(dataSet: dataSet)
    }
}

private extension ChartDataEntry {
    convenience init(_ points: Point) {
        self.init(x: points.x, y: points.y)
    }
}
