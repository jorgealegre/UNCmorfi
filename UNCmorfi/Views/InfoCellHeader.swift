//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import TinyConstraints
import UNCmorfiKit

class InfoCellHeader: UITableViewHeaderFooterView {

    // MARK: - Subviews

    private let label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    // MARK: - Properties

    static let reuseID = "InfoCellHeader"

    // MARK: - Initializers

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        // Hierarchy
        contentView.addSubviews(label)

        // Layout
        label.edges(to: contentView.layoutMarginsGuide)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configureFor(info: Information) {
        label.text = info.rawValue.localized()
    }
}
