//
//  ErrorResponseHandler.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import Foundation

open class ErrorResponseHandler: ResponseHandler {
    
    private let jsonDecoder = JSONDecoder()
    
    public func handle<T: Codable>(request: ApiRequest<T>,
                                   response: NetworkResponse,
                                   observer: @escaping (Result<T, ResponseErrorEntity>) -> Void) -> Bool {
        
        if let urlResponse = response.urlResponse,
           let nsHttpUrlResponse = urlResponse as? HTTPURLResponse,
           (300..<600).contains(nsHttpUrlResponse.statusCode) {
            
            let errorEntity = ResponseErrorEntity(response.urlResponse)
            
            errorEntity.errors.append("|| \(nsHttpUrlResponse.statusCode) ||\n")
            
            switch nsHttpUrlResponse.statusCode {
            case (300..<400):
                errorEntity.errors.append("Redirect Error.\n")
            case 403:
                errorEntity.errors.append("Please authorize. You need to authenticate")
            case 422:
                errorEntity.errors.append("please authorize. You need to authenticate.")
            case (400..<500):
                errorEntity.errors.append("Bad Request.\n")
            case (500..<600):
                errorEntity.errors.append("Server Error.\n")
            default:
                errorEntity.errors.append("Unknown Error.\n")
            }
            
            if response.data?.count == 0 {
                errorEntity.errors.append("Zero Data error")
            }
            
            observer(.failure(errorEntity))
            
            return true
        }
        
        return false
    }
}
