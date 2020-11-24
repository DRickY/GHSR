//
//  UITableView+Extension.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import UIKit


public protocol Chainable {
    func chain<C>(_ closure: (C) -> ()) -> Self
}

public extension Chainable {
    
    @discardableResult
    func chain<C>(_ closure: (C) -> ()) -> Self {
        if case let newValue? = (self as? C) {
            closure(newValue)
        }
        return self
    }
}

extension UIView: Chainable {}

public extension UITableView {
    func indexPath(for view: UIView) -> IndexPath? {
        let point = view.convert(CGPoint.zero, to: self)
        
        return self.indexPathForRow(at: point)
    }
}

public extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>(with cls: T.Type, at indexPath: IndexPath, configurator: (T) -> Void) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: toString(cls), for: indexPath)
        
        return cell.chain(configurator)
    }
    
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
