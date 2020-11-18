//
//  Collection+Extension.swift
//  GHSR
//
//  Created by Dmytro.k on 11/18/20.
//

import Foundation

public extension Collection {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
