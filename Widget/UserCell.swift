//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import AlamofireImage

class UserCell: UITableViewCell {

    static let reuseID = "UserCell"

    // MARK: - Subviews

    private let photoImageView: LoadingImageView = {
        let imageView = LoadingImageView(image: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        imageView.layer.cornerRadius = 7.5
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        let margin = contentView.layoutMarginsGuide

        contentView.addSubviews(nameLabel, balanceLabel, photoImageView)

        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            photoImageView.topAnchor.constraint(equalTo: margin.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 5),
            nameLabel.centerYAnchor.constraint(equalTo: margin.centerYAnchor),
            balanceLabel.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            balanceLabel.centerYAnchor.constraint(equalTo: margin.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configureFor(user: User) {
        balanceLabel.text = "$\(user.balance)"
        nameLabel.text = user.name

        if let imageURL = user.imageURL {
            photoImageView.isLoading = true
            photoImageView.af_setImage(withURL: imageURL) { [weak self] _ in
                self?.photoImageView.isLoading = false
            }
        }
    }
}
