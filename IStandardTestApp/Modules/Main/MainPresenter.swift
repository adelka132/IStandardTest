import Foundation

protocol MainPresenterProtocol {
    func tapButton(count points: String?)
}

// MARK: - MainPresenter

final class MainPresenter {

    private weak var view: MainViewProtocol?
    private let networkService: PointServiceable
    private let completionHandler: (MainRoute) -> Void

    // MARK: - Initialization

    init(view: MainViewProtocol,
         networkService: PointServiceable,
         completion: @escaping (MainRoute) -> Void)
    {
        self.view = view
        self.networkService = networkService
        self.completionHandler = completion
    }

    @MainActor
    private func fetchPoints(count: Int) async {
        view?.startLoading()
        defer { view?.stopLoading() }

        let result = await networkService.getPoints(count: count)

        switch result {
        case .success(let success):
            self.completionHandler(.showGraphic(success.points))
        case .failure(let failure):
            self.view?.showAlert(title: "Ошибка", message: failure.localizedDescription)
        }
    }
}

// MARK: - MainPresenterProtocol

extension MainPresenter: MainPresenterProtocol {
    func tapButton(count points: String?) {
        guard
            let points = points,
            let intPoints = Int(points)
        else {
            view?.showAlert(title: "Ошибка", message: "Введите число")
            return
        }

        Task { [weak self] in
            await self?.fetchPoints(count: intPoints)
        }
    }
}
