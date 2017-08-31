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
        return label
    }()

    let balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let margin = contentView.layoutMarginsGuide
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(balanceLabel)
        contentView.addSubview(photoImageView)
        
        photoImageView.leadingAnchor.constraint(equalTo: margin.leadingAnchor).isActive = true
        photoImageView.topAnchor.constraint(equalTo: margin.topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: margin.bottomAnchor).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 5).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: margin.trailingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: margin.topAnchor).isActive = true
        
        balanceLabel.trailingAnchor.constraint(equalTo: margin.trailingAnchor).isActive = true
        balanceLabel.bottomAnchor.constraint(equalTo: margin.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
