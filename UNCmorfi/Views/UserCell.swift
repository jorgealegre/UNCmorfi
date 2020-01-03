//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import TinyConstraints
import AlamofireImage
import UNCmorfiKit
import UNCmorfiUI

class UserCell: UITableViewCell {

    // MARK: - Properties

    static let reuseID = "UserCell"

    private enum Constants {
        static let photoImageViewWidth: CGFloat = 50
    }

    // MARK: - Subviews

    private let photoImageView: LoadingImageView = {
        let imageView = LoadingImageView(image: nil)
        imageView.width(Constants.photoImageViewWidth, priority: .required - 1)
        imageView.heightToWidth(of: imageView)
        imageView.layer.cornerRadius = Constants.photoImageViewWidth / 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.accessibilityIdentifier = "user-image"
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "user-name"
        return label
    }()

    private let expirationDateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "user-expiration-date"
        if #available(iOS 13.0, *) {
            label.textColor = UIColor.secondaryLabel
        }
        return label
    }()
    
    private let barcodeLabel: UILabel = {
        let label = UILabel()
        let fontSize = UIFont.preferredFont(forTextStyle: .body).pointSize
        if #available(iOS 12.0, *) {
            label.font = UIFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        } else {
            label.font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .regular)
        }
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "user-barcode"
        return label
    }()

    private let balanceLabel: UILabel = {
        let label = UILabel()
        let fontSize = UIFont.preferredFont(forTextStyle: .headline).pointSize
        if #available(iOS 12.0, *) {
            label.font = UIFont.monospacedSystemFont(ofSize: fontSize, weight: .bold)
        } else {
            label.font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .bold)
        }
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "user-balance"
        return label
    }()

    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        // Hierarchy
        let labelStack = UIStackView(arrangedSubviews: [nameLabel, expirationDateLabel, barcodeLabel])
        labelStack.axis = .vertical
        labelStack.alignment = .leading
        labelStack.spacing = 2
        labelStack.setCustomSpacing(5, after: nameLabel)
        contentView.addSubviews(labelStack, balanceLabel, photoImageView)

        // Layout
        let margin = contentView.layoutMarginsGuide
        photoImageView.leading(to: margin)
        photoImageView.centerY(to: margin)
        photoImageView.top(to: margin, relation: .equalOrGreater)
        photoImageView.bottom(to: margin, relation: .equalOrLess)
        labelStack.leadingToTrailing(of: photoImageView, offset: 10)
        labelStack.trailing(to: margin)
        labelStack.top(to: margin)
        labelStack.bottom(to: margin)
        balanceLabel.trailing(to: margin)
        balanceLabel.bottom(to: margin)

        // Configuration
        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configureFor(user: User) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long

        balanceLabel.text = NumberFormatter.balanceFormatter.string(from: user.balance as NSNumber)
        nameLabel.text = user.name
        expirationDateLabel.text = "\(String.expires): \(dateFormatter.string(from: user.expirationDate))"
        barcodeLabel.text = user.code

        if let imageURL = user.imageURL {
            photoImageView.isLoading = true
            photoImageView.af_setImage(withURL: imageURL) { [weak self] _ in
                self?.photoImageView.isLoading = false
            }
        }
    }
}
