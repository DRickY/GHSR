//
//  BodyConvertible.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import Foundation

protocol BodyConvertible: AnyObject {
    func createBody() -> Data
}
