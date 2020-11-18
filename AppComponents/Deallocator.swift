//
//  Deallocator.swift
//  GHSR
//
//  Created by Dmytro.k on 11/18/20.
//

import Foundation

class Deallocator {
   
    public let id: String
    private let disposable: () -> Void

    public init(id: String = "", _ disposable: @escaping () -> Void) {
        self.id = id
        self.disposable = disposable
    }
    
    deinit {
        self.disposable()
    }
}

extension Deallocator: Equatable {
    static func == (lhs: Deallocator, rhs: Deallocator) -> Bool {
        return lhs === rhs
    }
}
