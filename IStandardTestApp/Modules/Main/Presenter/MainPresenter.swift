import Foundation

protocol MainPresenterProtocol {
    func tapButton(count points: Int)
}

enum MainRoute {
    case showGraphic([Point])
}

// MARK: - MainPresenter

final class MainPresenter {

    weak var view: MainViewProtocol?
    private let networkService: PointService
    private let completionHandler: (MainRoute) -> Void

    // MARK: - Initialization

    init(view: MainViewProtocol,
         networkService: PointService,
         completion: @escaping (MainRoute) -> Void)
    {
        self.view = view
        self.networkService = networkService
        self.completionHandler = completion
    }

    @MainActor
    func fetchPoints(count: Int) async {
        view?.startSpinner()
        defer { view?.stopSpinner() }

        let result = await networkService.getPoints(count: count)

        switch result {
        case .success(let success):
            self.completionHandler(.showGraphic(success.points))
        case .failure(let failure):
            // FIXME: - Показывать это как алерт
            print(failure.localizedDescription)
        }
    }
}

// MARK: - MainPresenterProtocol

extension MainPresenter: MainPresenterProtocol {
    func tapButton(count points: Int) {
        Task { [weak self] in
            await self?.fetchPoints(count: points)
        }
    }
}
