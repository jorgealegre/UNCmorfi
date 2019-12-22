//
//  UserTableViewCell.swift
//  UNCmorfi
//
//  Created by George Alegre on 4/25/17.
//
//  LICENSE is at the root of this project's repository.
//

import UIKit
import AlamofireImage

class UserCell: UITableViewCell {

    // MARK: - Properties

    static let reuseIdentifier = "UserCell"

    private enum Constants {
        static let balanceFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = "ARS"
            formatter.currencySymbol = "$"
            formatter.maximumFractionDigits = 0
            return formatter
        }()

        static let photoImageViewHeight: CGFloat = 50
    }

    // MARK: - Subviews

    private let photoImageView: LoadingImageView = {
        let imageView = LoadingImageView(image: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: Constants.photoImageViewHeight)
        widthConstraint.priority = .required - 1
        widthConstraint.isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.layer.cornerRadius = Constants.photoImageViewHeight / 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let barcodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(for: .headline, weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let margin = contentView.layoutMarginsGuide
        
        contentView.addSubviews(nameLabel, barcodeLabel, balanceLabel, photoImageView)
        
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            photoImageView.topAnchor.constraint(equalTo: margin.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: margin.bottomAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 5),

            nameLabel.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: margin.topAnchor),

            barcodeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            barcodeLabel.topAnchor.constraint(greaterThanOrEqualTo: nameLabel.bottomAnchor),
            barcodeLabel.bottomAnchor.constraint(equalTo: margin.bottomAnchor),

            balanceLabel.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            balanceLabel.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configureFor(user: User) {
        balanceLabel.text = Constants.balanceFormatter.string(from: user.balance as NSNumber)
        nameLabel.text = user.name
        barcodeLabel.text = user.code

        if let imageURL = user.imageURL {
            photoImageView.isLoading = true
            photoImageView.af_setImage(withURL: imageURL) { [weak self] _ in
                self?.photoImageView.isLoading = false
            }
        }
    }
}
