//
//  UINib+Extension.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import UIKit

public extension UINib {
    convenience init(_ viewClass: AnyClass, _ bundle: Bundle? = nil) {
        self.init(nibName: toString(viewClass), bundle: bundle)
    }
}
