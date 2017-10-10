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

    let balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Black", size: 16)
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

    func configureFor(user: User) {
        balanceLabel.text = "$\(user.balance)"
        nameLabel.text = user.name
        photoImageView.image = user.image
    }
}
