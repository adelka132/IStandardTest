import UIKit
import Charts

protocol GraphicViewProtocol: AnyObject {
    func configureTableView(by model: [Point])
    func updateGraphic(with data: LineChartData)
    func showAlert(title: String, message: String)
    func makeScreenshot()
}

final class GraphicViewController: UIViewController {

    var presenter: GraphicPresenterProtocol?
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var graphicView: LineChartView = {
        let gView = LineChartView()
        gView.backgroundColor = .systemBlue
        gView.translatesAutoresizingMaskIntoConstraints = false
        return gView
    }()

    private lazy var setPointsTableViewDataSource: UITableViewDiffableDataSource<Int, Point> = {
        .init(tableView: tableView) { tableView, indexPath, model in
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: GraphicCell.identifier,
                                                         for: indexPath) as? GraphicCell
            else { return UITableViewCell() }

            cell.set(model: model)
            return cell
        }
    }()
    
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearence()

        presenter?.viewDidLoad()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updateViewsForOrientation()
    }
}

// MARK: - GraphicViewProtocol

extension GraphicViewController: GraphicViewProtocol {

    func updateGraphic(with data: LineChartData) {
        graphicView.data = data
    }

    func configureTableView(by model: [Point]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Point>()
        snapshot.appendSections([0])
        snapshot.appendItems(model, toSection: 0)
        setPointsTableViewDataSource.apply(snapshot)
    }

    func makeScreenshot() {
        if let image = graphicView.getChartImage(transparent: true) {
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           #selector(image(_:didFinishSavingWithError:contextInfo:)),
                                           nil)
        }
    }

    func showAlert(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ок", style: .default)
        alertView.addAction(alertAction)
        present(alertView, animated: true)
    }
}

// MARK: - Private Methods

private extension GraphicViewController {

    func configureAppearence() {
        view.addSubview(stackView)
        [tableView, graphicView].forEach { stackView.addArrangedSubview($0) }
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Screenshot",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(screenshotTapped))

        tableView.dataSource = setPointsTableViewDataSource
        tableView.register(GraphicCell.self, forCellReuseIdentifier: GraphicCell.identifier)
        makeConstraints()
    }

    func makeConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func updateViewsForOrientation() {
        tableView.isHidden = UIDevice.current.orientation.isLandscape
    }

    @objc func screenshotTapped() {
        presenter?.tappedScreenshot()
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        presenter?.didFinishSavingImage(error)
    }
}
