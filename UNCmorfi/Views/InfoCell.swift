//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import TinyConstraints

class InfoCell: UITableViewCell {

    // MARK: - Properties

    static let reuseIdentifier = "InfoCell"

    // MARK: - Subviews

    /// Using a UITextView instead of a UILabel for allowing attributed
    /// strings and hyperlinks. This also allows the text to be highlightable.
    private let textView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.isScrollEnabled = false
        view.dataDetectorTypes = .link
        view.isUserInteractionEnabled = true
        view.adjustsFontForContentSizeCategory = true
        return view
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        // Hierarchy
        contentView.addSubviews(textView)

        // Layout
        textView.edges(to: contentView.layoutMarginsGuide)

        // Configuration
        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configureFor(info: Information) {
        let string = info.rawValue.appending(".body").localized()
        let components = string.components(separatedBy: "|")
        let attributedString = NSMutableAttributedString()

        components.enumerated().forEach { (index: Int, element: String) in
            if (index % 2 == 1) {
                // Element is a link with Markdown syntax ([name](link)).
                let visibleName = element[element.index(element.firstIndex(of: "[")!, offsetBy: 1)..<element.firstIndex(of: "]")!]
                let urlString = element[element.index(element.firstIndex(of: "(")!, offsetBy: 1)..<element.firstIndex(of: ")")!]

                let url: NSMutableAttributedString
                if #available(iOS 13.0, *) {
                    url = NSMutableAttributedString(string: String(visibleName), attributes: [.foregroundColor: UIColor.label])
                } else {
                    url = NSMutableAttributedString(string: String(visibleName))
                }
                url.addAttribute(.link, value: urlString, range: NSRange(location: 0, length: visibleName.count))

                attributedString.append(url)
            } else {
                let string: NSAttributedString
                if #available(iOS 13.0, *) {
                    string = NSAttributedString(string: element, attributes: [.foregroundColor: UIColor.label])
                } else {
                    string = NSAttributedString(string: element)
                }

                attributedString.append(string)
            }
        }

        let font = UIFont.preferredFont(forTextStyle: .body)
        attributedString.addAttribute(.font, value: font,
                                      range: NSRange(location: 0, length: attributedString.string.count))

        textView.attributedText = attributedString
    }
}
