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
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
