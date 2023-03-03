import Foundation
import Charts

protocol GraphicPresenterProtocol {
    func viewDidLoad()
    func tappedScreenshot()
    func didFinishSavingImage(_ error: Error?)
}

final class GraphicPresenter {

    private weak var view: GraphicViewProtocol?
    private let points: [Point]

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

    func didFinishSavingImage(_ error: Error?) {
        if let error = error {
            view?.showAlert(title: "Ошибка", message: error.localizedDescription)
        } else {
            view?.showAlert(title: "Успешно", message: "Скриншот сохранён в фото")
        }
    }

    func tappedScreenshot() {
        view?.makeScreenshot()
    }
}

private extension ChartDataEntry {
    convenience init(_ points: Point) {
        self.init(x: points.x, y: points.y)
    }
}
