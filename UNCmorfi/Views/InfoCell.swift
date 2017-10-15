//
//  InfoCell.swift
//  UNCmorfi
//
//  Created by George Alegre on 09/10/2017.
//
//  LICENSE is at the root of this project's repository.
//

import UIKit

class InfoCell: UITableViewCell, UITextViewDelegate {
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
        view.dataDetectorTypes = .link
        view.isUserInteractionEnabled = true
        return view
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
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
        let string = info.rawValue.appending(".body").localized()
        let components = string.components(separatedBy: "|")
        let attributedString = NSMutableAttributedString()

        components.enumerated().forEach { (index: Int, element: String) in
            if (index % 2 == 1) {
                // Element is a link with Markdown syntax ([name](link)).
                let visibleName = element[element.index(element.index(of: "[")!, offsetBy: 1)..<element.index(of: "]")!]
                let urlString = element[element.index(element.index(of: "(")!, offsetBy: 1)..<element.index(of: ")")!]

                let url = NSMutableAttributedString(string: String(visibleName))
                url.addAttribute(.link, value: urlString, range: NSRange(location: 0, length: visibleName.count))

                attributedString.append(url)
            } else {
                attributedString.append(NSAttributedString(string: element))
            }
        }

        textView.attributedText = attributedString
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        print(URL)
        return false
    }
}
