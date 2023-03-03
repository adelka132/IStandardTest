import Foundation
import Charts

protocol GraphicPresenterProtocol {
    var points: [Point] { get }
    func viewDidLoad()
}

final class GraphicPresenter {

    private weak var view: GraphicViewProtocol?
    let points: [Point]

    init(view: GraphicViewProtocol?, points: [Point]) {
        self.view = view
        self.points = points.sorted(by: { $0.x < $1.x })
    }

    private func getDataForGraphic() -> LineChartData {
        let points = points.map(ChartDataEntry.init)
        let dataSet = LineChartDataSet(entries: points)
        dataSet.mode = .cubicBezier
        return LineChartData(dataSet: dataSet)
    }
}

extension GraphicPresenter: GraphicPresenterProtocol {

    func viewDidLoad() {
        view?.configureTableView(by: points)

        let data = getDataForGraphic()
        view?.updateGraphic(with: data)
    }
}

private extension ChartDataEntry {
    convenience init(_ points: Point) {
        self.init(x: points.x, y: points.y)
    }
}
