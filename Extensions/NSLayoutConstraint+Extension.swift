//
//  NSLayoutConstraint+Extension.swift
//  GHSR
//
//  Created by Dmytro.k on 11/18/20.
//

import UIKit

extension NSLayoutConstraint {
    func setPriopity(priority: Float) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(rawValue: priority)
        return self
    }
}
