//
//  UserTableViewCell.swift
//  UNCmorfi
//
//  Created by George Alegre on 4/25/17.
//
//  LICENSE is at the root of this project's repository.
//

import UIKit

class UserCell: UITableViewCell {
    // MARK: Properties
    static let reuseIdentifier = "UserCell"
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Medium", size: 20)
        return label
    }()
    
    let barcodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Regular", size: 14)
        return label
    }()

    let balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Bold", size: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let margin = contentView.layoutMarginsGuide
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(barcodeLabel)
        contentView.addSubview(balanceLabel)
        contentView.addSubview(photoImageView)
        
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

    func configureFor(user: User) {
        balanceLabel.text = "$\(user.balance)"
        nameLabel.text = user.name
        photoImageView.image = user.image
        barcodeLabel.text = user.code
    }
}
