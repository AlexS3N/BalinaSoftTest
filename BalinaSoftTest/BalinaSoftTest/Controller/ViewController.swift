import UIKit

final class ViewController: UIViewController, UINavigationControllerDelegate {

    //MARK: - var/let
    private let tableView = UITableView()
    private let viewModel = ViewModel()
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        constraintsViews()
        viewModel.getData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Flow functions
    private func setupViews() {
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func constraintsViews() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
}

//MARK: - TableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.fetchedData?.content.count ?? 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseID, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        if let pictures = viewModel.fetchedData?.content[indexPath.row] {
            cell.configure(with: pictures)
        }
        cell.separatorInset = .zero
        return cell
    }
}

//MARK: - TableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        takePhoto()
        viewModel.sendID(indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let name = ImageManager.shared.saveImage(image)
            viewModel.namePhoto = name
        }
        self.dismiss(animated: true, completion: nil)
    }
}
