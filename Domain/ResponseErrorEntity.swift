//
//  ResponseErrorEntity.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import Foundation

public struct ResponseErrorEntity: Error, LocalizedError {
    
    public var errors = [String]()
    
    public let urlResponse: URLResponse?
    
    public let urlRequest: URLRequest?
    
    public var statusCode: Int? {
        return (self.urlResponse as? HTTPURLResponse)?.statusCode
    }
    
    public var errorDescription: String? {
        return errors.joined()
    }

    public init(_ urlResponse: URLResponse? = nil, _ urlRequest: URLRequest? = nil) {
        self.urlResponse = urlResponse
        self.urlRequest = urlRequest
    }
}
