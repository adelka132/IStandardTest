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
        Task(priority: .background) {
            let result = await networkService.getPoints(count: count)
            switch result {
            case .success(let success):
                print(success.points)
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
