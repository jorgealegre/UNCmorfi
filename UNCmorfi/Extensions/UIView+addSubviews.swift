//
//  UIView+addSubviews.swift
//  UNCmorfi
//
//  Created by George Alegre on 18/12/2019.
//  Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview)
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach(addArrangedSubview)
    }
}
