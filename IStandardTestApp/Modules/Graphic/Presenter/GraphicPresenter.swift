import Foundation
import Charts

protocol GraphicPresenterProtocol {
    var numberOfRows: Int { get }

    func viewDidAppear()
    func dataFor(row: Int) -> Point?
    func getDataForGraphic() -> LineChartData
}

final class GraphicPresenter {

    weak var view: GraphicViewProtocol?
    private let points: [Point]

    init(view: GraphicViewProtocol?, points: [Point]) {
        self.view = view
        self.points = points.sorted(by: <)
    }
}

extension GraphicPresenter: GraphicPresenterProtocol {

    var numberOfRows: Int { points.count }

    func viewDidAppear() {
        view?.updateTableView()
        view?.updateGraphic()
    }

    func dataFor(row: Int) -> Point? { points[safe: row] }

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
