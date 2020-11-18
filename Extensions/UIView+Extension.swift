//
//  UIView+Extension.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import UIKit

extension UIView {
    @discardableResult
    func addSubview<ViewType>(_ subview: ViewType, configure: (ViewType) -> Void) -> ViewType
    where ViewType: UIView
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subview)
        configure(subview)
        return subview
    }
}
