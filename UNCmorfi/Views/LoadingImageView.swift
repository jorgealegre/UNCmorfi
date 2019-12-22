//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import TinyConstraints

class LoadingImageView: UIImageView {

    // MARK: - Subviews

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            indicator = UIActivityIndicatorView(style: .medium)
        } else {
            indicator = UIActivityIndicatorView(style: .gray)
        }
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - Properties

    var isLoading: Bool = true {
        didSet {
            if isLoading {
                image = nil
                loadingIndicator.startAnimating()
            } else {
                loadingIndicator.stopAnimating()
            }
        }
    }

    // MARK: - Initializers

    override init(image: UIImage?) {
        super.init(image: image)

        // Hierarchy
        addSubviews(loadingIndicator)

        // Layout
        loadingIndicator.centerInSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
