//
//  NetworkRequest.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import Foundation

protocol NetworkRequest: AnyObject {
    var request: URLRequest { get }
}
