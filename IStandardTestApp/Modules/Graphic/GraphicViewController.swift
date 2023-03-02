import UIKit
import Charts

protocol GraphicViewProtocol: AnyObject {
    func updateTableView()
    func updateGraphic(with data: LineChartData)
}

final class GraphicViewController: UIViewController {

    var presenter: GraphicPresenterProtocol?

    private let tableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let graphicView: LineChartView = {
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

    // MARK: - Contstraints

    private lazy var equalHeight = graphicView.heightAnchor.constraint(equalTo: tableView.heightAnchor)
    private lazy var graphicLeading = graphicView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
    private lazy var landscapeGraphcLeading = graphicView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearence()

        presenter?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.window?.windowScene?.interfaceOrientation == .landscapeRight {
            equalHeight.isActive = false
            graphicLeading.isActive = false
            landscapeGraphcLeading.isActive = true
        } else {
            equalHeight.isActive = true
            graphicLeading.isActive = true
            landscapeGraphcLeading.isActive = false
        }
    }
}

// MARK: - GraphicViewProtocol

extension GraphicViewController: GraphicViewProtocol {

    func updateTableView() {
        configure(by: presenter?.points ?? [])
    }

    func updateGraphic(with data: LineChartData) {
        graphicView.data = data
    }
}

// MARK: - Private Methods

private extension GraphicViewController {

    func configureAppearence() {
        view.addSubview(tableView, graphicView)
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
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            graphicView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            graphicView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            graphicLeading,
            graphicView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            equalHeight
        ])
    }

    func configure(by model: [Point]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Point>()
        snapshot.appendSections([0])
        snapshot.appendItems(model, toSection: 0)
        setPointsTableViewDataSource.apply(snapshot)
    }

    @objc func screenshotTapped() {
        if let image = graphicView.getChartImage(transparent: true) {
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           #selector(image(_:didFinishSavingWithError:contextInfo:)),
                                           nil)
        }
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(title: "Ошибка", message: error.localizedDescription)
        } else {
            showAlert(title: "Успешно", message: "Скриншот сохранён")
        }
    }

    func showAlert(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ок", style: .default)
        alertView.addAction(alertAction)
        present(alertView, animated: true)
    }
}