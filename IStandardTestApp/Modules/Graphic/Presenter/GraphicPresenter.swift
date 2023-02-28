import Foundation

protocol GraphicPresenterProtocol {
    var numberOfRows: Int { get }

    func viewDidLoad()
    func viewDidAppear()
    func dataFor(row: Int) -> Point?
}

final class GraphicPresenter {

    weak var view: GraphicViewProtocol?
    private let graphicData: GraphicData

    init(view: GraphicViewProtocol?, graphicData: GraphicData) {
        self.view = view
        self.graphicData = graphicData
    }
}

extension GraphicPresenter: GraphicPresenterProtocol {

    var numberOfRows: Int { graphicData.points.count }

    func viewDidLoad() {
        view?.configureAppearence()
    }

    func viewDidAppear() {
        view?.updateTableView()
    }

    func dataFor(row: Int) -> Point? {
        graphicData.points[safe: row]
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
