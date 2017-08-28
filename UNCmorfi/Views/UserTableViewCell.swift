//
//  UserTableViewCell.swift
//  UNCmorfi
//
//  Created by George Alegre on 4/25/17.
//  Copyright © 2017 George Alegre. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    // MARK: Properties
    static let reuseIdentifier = "UserTableViewCell"
    
    var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.layer.cornerRadius = imageView.bounds.size.width / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()

    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .yellow

        return label
    }()

    var balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .green
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(balanceLabel)
        contentView.addSubview(photoImageView)
        
        photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 5).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        
        balanceLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -50).isActive = true
        balanceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        
//        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[image]-5-[name]->=0-[balance]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["image": photoImageView, "name": nameLabel, "balance": balanceLabel]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
