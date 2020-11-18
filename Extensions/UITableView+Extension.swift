//
//  UITableView+Extension.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import UIKit

public extension UITableView {
    func indexPath(for view: UIView) -> IndexPath? {
        let point = view.convert(CGPoint.zero, to: self)
        
        return self.indexPathForRow(at: point)
    }
}

public extension UITableView {
    func dequeueReusableCell(with cls: AnyClass, at indexPath: IndexPath) -> UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: toString(cls), for: indexPath)
    }
    
    func dequeueReusableHeaderFooterView(with cls: AnyClass) -> UITableViewHeaderFooterView? {
        return self.dequeueReusableHeaderFooterView(withIdentifier: toString(cls))
    }
    
    func register(classes cells: AnyClass...) {
        self.register(classes: cells)
    }
    
    func register(nibs cells: AnyClass...) {
        self.register(nibs: cells)
    }
    
    func register(classes cells: [AnyClass]) {
        cells.forEach(self.register(cellClass:))
    }
    
    func register(nibs cells: [AnyClass]) {
        cells.forEach(self.register(cellNib:))
    }
    
    func register(cellClass type: AnyClass) {
        self.register(type, forCellReuseIdentifier: toString(type))
    }
    
    func register(cellNib type: AnyClass) {
        self.register(UINib(type), forCellReuseIdentifier: toString(type))
    }
}
