import Foundation
import Charts

protocol GraphicPresenterProtocol {
    var numberOfRows: Int { get }

    func viewDidLoad()
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

    func viewDidLoad() {
        view?.configureAppearence()
    }

    func viewDidAppear() {
        view?.updateTableView()
        view?.updateGraphic()
    }

    func dataFor(row: Int) -> Point? { points[safe: row] }

    func getDataForGraphic() -> LineChartData {
        let points = points.compactMap { ChartDataEntry(x: $0.x, y: $0.y) }
        let dataSet = LineChartDataSet(entries: points)
        dataSet.mode = .cubicBezier
        return LineChartData(dataSet: dataSet)
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
