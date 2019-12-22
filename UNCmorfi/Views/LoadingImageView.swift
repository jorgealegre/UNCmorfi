//
//  LoadingImageView.swift
//  UNCmorfi
//
//  Created by George Alegre on 19/12/2019.
//  Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit

class LoadingImageView: UIImageView {

    // MARK: - Subviews

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            indicator = UIActivityIndicatorView(style: .medium)
        } else {
            indicator = UIActivityIndicatorView(style: .gray)
        }
        indicator.translatesAutoresizingMaskIntoConstraints = false
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

        translatesAutoresizingMaskIntoConstraints = false

        addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
