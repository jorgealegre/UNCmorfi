//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit

class FoodCell: UITableViewCell {
    static let reuseIdentifier = "FoodCell"

    let containerView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false

        view.layer.cornerRadius = 3

        view.layer.borderColor = UIColor.systemOrange.cgColor
        view.layer.borderWidth = 1
        
        return view
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    let mealsStackView: UIStackView = {
        let range = 1...3
        let mealLabels = range.map { _ -> UILabel in
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .preferredFont(forTextStyle: .body)
            label.adjustsFontForContentSizeCategory = true
            label.numberOfLines = 0
            return label
        }

        let stackView = UIStackView(arrangedSubviews: mealLabels)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let margin = contentView.layoutMarginsGuide

        contentView.addSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: margin.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: margin.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: margin.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: margin.bottomAnchor).isActive = true

        containerView.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true

        containerView.addSubview(mealsStackView)
        mealsStackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10).isActive = true
        mealsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
        mealsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        mealsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
    }
}
