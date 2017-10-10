//
//  InfoCell.swift
//  UNCmorfi
//
//  Created by George Alegre on 09/10/2017.
//
//  LICENSE is at the root of this project's repository.
//

import UIKit

class InfoCell: UITableViewCell {
    // MARK: Properties
    static let reuseIdentifier = "InfoCell"

    /* Using a UITextView instead of a UILabel for allowing attributed
     * strings and hyperlinks. This also allows the text to be highlightable.
     */
    private let textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isEditable = false
        // This allows the UITextView to set its intrinsicContentSize.
        view.isScrollEnabled = false
        return view
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        selectionStyle = .none

        let margin = contentView.layoutMarginsGuide
        contentView.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            textView.topAnchor.constraint(equalTo: margin.topAnchor),
            textView.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureFor(info: Information) {
        textView.attributedText = NSAttributedString(string: info.rawValue.localized() + "jajajaja")
    }
}
