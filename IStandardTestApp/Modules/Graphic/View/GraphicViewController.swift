import UIKit
import Charts

protocol GraphicViewProtocol: AnyObject {
    func configureAppearence()
    func updateTableView()
    func updateGraphic()
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

    // MARK: - Contstraints

    private lazy var equalHeight = graphicView.heightAnchor.constraint(equalTo: tableView.heightAnchor)
    private lazy var graphicLeading = graphicView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
    private lazy var landscapeGraphcLeading = graphicView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidAppear()
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

    func configureAppearence() {
        view.addSubview(tableView, graphicView)
        view.backgroundColor = .systemBackground

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GraphicCell.self, forCellReuseIdentifier: GraphicCell.identifier)

        makeConstraints()
    }

    func updateTableView() {
        tableView.reloadData()
    }

    func updateGraphic() {
        graphicView.data = presenter?.getDataForGraphic()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension GraphicViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfRows ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: GraphicCell.identifier, for: indexPath) as? GraphicCell,
            let data = presenter?.dataFor(row: indexPath.row)
        else { return UITableViewCell() }

        cell.set(model: data)
        return cell
    }
}

// MARK: - Private Methods

private extension GraphicViewController {
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
}
