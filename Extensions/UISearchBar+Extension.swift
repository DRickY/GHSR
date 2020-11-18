//
//  UISearchBar+Extension.swift
//  GHSR
//
//  Created by Dmytro.k on 11/18/20.
//

import UIKit

extension UISearchBar {
    func clear() {
        self.text = ""
        self.showsSearchResultsButton = false
        self.setShowsCancelButton(false, animated: true)
    }
}
