//
//  ResponseHandler.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import Foundation

public typealias NetworkResponse = (data: Data?, urlResponse: URLResponse?, error: Error?)

public protocol ResponseHandler {
    
    func handle<T: Codable>(request: ApiRequest<T>,
                            response: NetworkResponse,
                            observer: @escaping (Result<T, ResponseErrorEntity>) -> Void) -> Bool
}
