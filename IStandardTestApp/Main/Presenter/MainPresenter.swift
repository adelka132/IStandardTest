import Foundation

protocol MainPresenterProtocol {
    func viewDidLoad()
    func tapButton()
}

// MARK: - MainPresenter

final class MainPresenter {

    weak var view: MainViewProtocol?
    private let networkService: PointService

    // MARK: - Initialization

    init(view: MainViewProtocol, networkService: PointService) {
        self.view = view
        self.networkService = networkService
    }

    func fetchPoints(count: Int) {
        view?.startSpinner()
        Task(priority: .background) { [weak self] in
            guard let self = self else { return }
            let result = await networkService.getPoints(count: count)
            switch result {
            case .success(let success):
                print(success.points)
            case .failure(let failure):
                print(failure.customMessage)
            }
            self.view?.stopSpinner()
        }
    }
}

// MARK: - MainPresenterProtocol

extension MainPresenter: MainPresenterProtocol {
    func viewDidLoad() {
        view?.configureAppearence()
    }

    func tapButton() {
        fetchPoints(count: 4)
    }
}
