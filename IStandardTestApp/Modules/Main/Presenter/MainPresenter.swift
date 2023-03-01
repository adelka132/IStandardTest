import Foundation

protocol MainPresenterProtocol {
    func viewDidLoad()
    func tapButton()
}

enum MainRout {
    case showGraphic(GraphicData)
}

// MARK: - MainPresenter

final class MainPresenter {

    weak var view: MainViewProtocol?
    private let networkService: PointService
    private let completionHandler: (MainRout) -> Void

    // MARK: - Initialization

    init(view: MainViewProtocol,
         networkService: PointService, completion: @escaping (MainRout) -> Void) {
        self.view = view
        self.networkService = networkService
        self.completionHandler = completion
    }

    func fetchPoints(count: Int) {
        view?.startSpinner()
        Task(priority: .background) { [weak self] in
            guard let self = self else { return }
            let result = await networkService.getPoints(count: count)

            self.view?.stopSpinner()
            switch result {
            case .success(let success):
                print(success.points)
                DispatchQueue.main.async {
                    self.completionHandler(.showGraphic(success))
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
