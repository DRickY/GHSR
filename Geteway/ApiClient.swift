//
//  ApiClient.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import Foundation

protocol ApiClient: AnyObject {
    var interceptors: [Interceptor] { set get }
    var responseHandlersQueue: [ResponseHandler] { set get }
    
    func execute<T: Codable>(request: ApiRequest<T>, _ callback: @escaping (Result<T, ResponseErrorEntity>) -> Void)
}
