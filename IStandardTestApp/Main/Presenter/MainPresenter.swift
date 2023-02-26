import Foundation

protocol MainPresenterProtocol {
    func viewDidLoad()
}

// MARK: - MainPresenter

final class MainPresenter {

    weak var view: MainViewProtocol?

    // MARK: - Initialization

    init(view: MainViewProtocol) {
        self.view = view
    }
}

// MARK: - MainPresenterProtocol

extension MainPresenter: MainPresenterProtocol {
    func viewDidLoad() {
        view?.configureAppearence()
    }
}
