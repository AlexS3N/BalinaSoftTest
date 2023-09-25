import UIKit
import Kingfisher

final class TableViewCell: UITableViewCell {
    
    //MARK: - var/let
    static let reuseID = "TableViewCell"
    private let title = UILabel()
    private let pictureView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        constraintsViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        constraintsViews()
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    func configure(with data: Content) {
        title.text = data.name
        if let url = data.image,
           let imageURL = URL(string: url) {
            pictureView.kf.setImage(with: imageURL)
        } else {
            pictureView.image = UIImage(named: "question")
        }
    }
}

extension TableViewCell {
    //MARK: - Flow functions
    private func setupViews() {
        addSubview(pictureView)
        addSubview(title)
        title.textAlignment = .center
        pictureView.backgroundColor = .white
        pictureView.contentMode = .scaleAspectFit
        pictureView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func constraintsViews() {
                
        NSLayoutConstraint.activate([
            pictureView.heightAnchor.constraint(equalToConstant: 100),
            pictureView.widthAnchor.constraint(equalToConstant: 100),
            pictureView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            pictureView.centerXAnchor.constraint(equalTo: centerXAnchor),

            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.topAnchor.constraint(equalTo: pictureView.bottomAnchor, constant: 10)
        ])
    }
}



