import Foundation

protocol MainPresenterProtocol {
    func viewDidLoad()
    func tapButton()
}

// MARK: - MainPresenter

final class MainPresenter {

    weak var view: MainViewProtocol?
    var coordinator: MainViewCoordinatorProtocol?
    private let networkService: PointService

    // MARK: - Initialization

    init(view: MainViewProtocol, networkService: PointService, coordinator: MainViewCoordinatorProtocol) {
        self.view = view
        self.networkService = networkService
        self.coordinator = coordinator
    }

    func fetchPoints(count: Int) {
        view?.startSpinner()
        Task(priority: .background) { [weak self] in
            guard let self = self else { return }
            let result = await networkService.getPoints(count: count)

            self.view?.stopSpinner()
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.coordinator?.showGraphic(with: success)
                }
            case .failure(let failure):
                print(failure.customMessage)
            }
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
