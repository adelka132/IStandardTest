import UIKit

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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UITableViewCell else {
            return UITableViewCell()
        }
        guard let data = presenter?.dataFor(row: indexPath.row) else { return UITableViewCell() }
        
        var cellConfig = cell.defaultContentConfiguration()
        cellConfig.text = "x: \(data.x) y: \(data.y)"
        return cell
    }
}

// MARK: - GraphicViewProtocol

extension GraphicViewController: GraphicViewProtocol {

    func configureAppearence() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func updateTableView() {
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
}

// MARK: - Private Methods

private extension GraphicViewController {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
