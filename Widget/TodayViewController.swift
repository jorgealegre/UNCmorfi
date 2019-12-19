//
//  TodayViewController.swift
//  Widget
//
//  Created by George Alegre on 13/11/2019.
//  Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import NotificationCenter
import Alamofire
import AlamofireImage

class UserCell: UITableViewCell {

    static let reuseID = "UserCell"

    // MARK: - Subviews

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        imageView.layer.cornerRadius = 7.5
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        let margin = contentView.layoutMarginsGuide

        contentView.addSubview(nameLabel)
        contentView.addSubview(balanceLabel)
        contentView.addSubview(photoImageView)

        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            photoImageView.topAnchor.constraint(equalTo: margin.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 5),
            nameLabel.centerYAnchor.constraint(equalTo: margin.centerYAnchor),
            balanceLabel.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            balanceLabel.centerYAnchor.constraint(equalTo: margin.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configureFor(user: User) {
        balanceLabel.text = "$\(user.balance)"
        nameLabel.text = user.name

        if let imageURL = user.imageURL {
            photoImageView.af_setImage(withURL: imageURL)
        }
    }
}

@objc(TodayViewController)
class TodayViewController: UITableViewController, NCWidgetProviding {
        
    override func viewDidLoad() {
        super.viewDidLoad()

        DataRequest.addAcceptableImageContentTypes(["application/octet-stream"])

        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseID)
        tableView.rowHeight = 40
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserStore.shared.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseID, for: indexPath) as! UserCell

        let user = UserStore.shared.users[indexPath.row]

        cell.configureFor(user: user)

        return cell
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
