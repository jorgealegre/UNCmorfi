//
//  FoodCell.swift
//  UNCmorfi
//
//  Created by George Alegre on 9/12/17.
//
//  LICENSE is at the root of this project's repository.
//

import UIKit

class FoodCell: UITableViewCell {
    static let reuseIdentifier = "FoodCell"

    let containerView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = .white

        view.layer.cornerRadius = 3

        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 1

        return view
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let mealsStackView: UIStackView = {
        let range = 1...3
        let mealLabels = range.map { _ -> UILabel in
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
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

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
