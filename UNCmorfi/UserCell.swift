//
//  UserTableViewCell.swift
//  UNCmorfi
//
//  Created by George Alegre on 4/25/17.
//  Copyright © 2017 George Alegre. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    // MARK: Properties
//    var photoImageView: UIImageView = {
//        let imageView = UIImageView()
//        return imageView
//    }()
//    
//    var nameLabel: UILabel = {
//        let label = UILabel()
//        return label
//    }()
//    
//    var balanceLabel: UILabel = {
//        let label = UILabel()
//        return label
//    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        addSubview(photoImageView)
//        addSubview(nameLabel)
//        addSubview(balanceLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
