//
//  Reducable.swift
//  GHSR
//
//  Created by Dmytro.k on 11/23/20.
//

import Foundation

public protocol Defaultable {
    static var defaultValue: Self { get }
}

public protocol Reducable: Defaultable {
    
    associatedtype A: Action

    static func reducer(state: Self, action: A) -> Self
}
