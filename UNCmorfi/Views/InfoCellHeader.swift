//
//  InfoCellHeader.swift
//  UNCmorfi
//
//  Created by George Alegre on 09/10/2017.
//
//  LICENSE is at the root of this project's repository.
//

import UIKit

class InfoCellHeader: UIView {
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    convenience init() {
        self.init(frame: CGRect.zero)
        configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalTo: layoutMarginsGuide.heightAnchor),
            label.widthAnchor.constraint(equalTo: layoutMarginsGuide.widthAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }

    func configureFor(info: Information) {
        label.text = info.rawValue.localized()
    }
}
