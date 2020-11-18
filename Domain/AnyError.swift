//
//  AnyError.swift
//  GHSR
//
//  Created by Dmytro.k on 11/17/20.
//

import Foundation

struct AnyError: Error, LocalizedError, CustomStringConvertible {
    let error: Error? = nil
    var description: String { self.errorDescription ?? "" }
    
    var errorDescription: String? {
        return self.error?.localizedDescription
    }
}
