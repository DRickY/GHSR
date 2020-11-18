//
//  Interceptor.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import Foundation

public protocol Interceptor: AnyObject {
    
    func prepare<T: Codable>(request: ApiRequest<T>)

    func handle<T: Codable>(request: ApiRequest<T>, response: NetworkResponse)
}
