//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import TinyConstraints

class FoodCell: UITableViewCell {

    // MARK: - Properties

    static let reuseIdentifier = "FoodCell"

    private enum Constants {
        static let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.dateFormat = "EEEE d"
            return dateFormatter
        }()
    }

    // MARK: - Subviews

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.layer.borderColor = UIColor.systemOrange.cgColor
        view.layer.borderWidth = 1
        return view
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private let stackView: UIStackView = {
        let range = 1...3
        let mealLabels = range.map { _ -> UILabel in
            let label = UILabel()
            label.font = .preferredFont(forTextStyle: .body)
            label.adjustsFontForContentSizeCategory = true
            label.numberOfLines = 0
            return label
        }

        let stackView = UIStackView(arrangedSubviews: mealLabels)
        stackView.axis = .vertical
        return stackView
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        // Hierarchy
        contentView.addSubviews(containerView)
        stackView.insertArrangedSubview(dateLabel, at: 0)
        containerView.addSubviews(stackView)

        // Layout
        containerView.edges(to: contentView.layoutMarginsGuide)
        stackView.edgesToSuperview(insets: .uniform(10))
        stackView.setCustomSpacing(10, after: dateLabel)

        // Configuration
        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configure(date: Date, meals: [String]) {
        dateLabel.text = Constants.dateFormatter.string(from: date)

        meals.enumerated().forEach{ index, meal in
            let label = stackView.arrangedSubviews[index + 1] as! UILabel
            label.text = meal
        }
    }
}
