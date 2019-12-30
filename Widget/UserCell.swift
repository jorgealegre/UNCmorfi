//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import TinyConstraints
import UNCmorfiKit

class UserCell: UITableViewCell {

    // MARK: - Properties

    static let reuseID = "UserCell"

    private enum Constants {
        static let balanceFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = "ARS"
            formatter.currencySymbol = "$"
            formatter.maximumFractionDigits = 0
            return formatter
        }()
    }

    // MARK: - Subviews

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private let balanceLabel: UILabel = {
        let label = UILabel()
        let fontSize = UIFont.preferredFont(forTextStyle: .body).pointSize
        if #available(iOS 12.0, *) {
            label.font = UIFont.monospacedSystemFont(ofSize: fontSize, weight: .bold)
        } else {
            label.font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .bold)
        }
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Hierarchy
        contentView.addSubviews(nameLabel, balanceLabel)

        // Layout
        let margin = contentView.layoutMarginsGuide
        nameLabel.edges(to: margin, excluding: .right)
        balanceLabel.edges(to: margin, excluding: .left)

        // Configuration
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configureFor(user: User) {
        balanceLabel.text = Constants.balanceFormatter.string(from: user.balance as NSNumber)
        nameLabel.text = user.name
    }
}
