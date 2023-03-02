import UIKit
import Charts

protocol GraphicViewProtocol: AnyObject {
    func configureAppearence()
    func updateTableView()
}

final class GraphicViewController: UIViewController {

    var presenter: GraphicPresenterProtocol?

    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var graphicView: LineChartView = {
        let gView = LineChartView()
        gView.translatesAutoresizingMaskIntoConstraints = false
        return gView
    }()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidAppear()
    }
}

// MARK: - UITableViewDelegate

extension GraphicViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension GraphicViewController: UITableViewDataSource {

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

// MARK: - GraphicViewProtocol

extension GraphicViewController: GraphicViewProtocol {

    func configureAppearence() {
        view.addSubview(tableView)
        view.addSubview(graphicView)
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GraphicCell.self, forCellReuseIdentifier: GraphicCell.identifier)

        makeConstraints()
    }

    func updateTableView() {
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
}

// MARK: - Private Methods

private extension GraphicViewController {
    func makeConstraints() {
        let equalHeight = NSLayoutConstraint(item: tableView,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: graphicView,
                                             attribute: .height,
                                             multiplier: 1.0,
                                             constant: 0.0)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            graphicView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            graphicView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            graphicView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            graphicView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            equalHeight
        ])
    }
}
