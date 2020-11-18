//
//  JsonResponseHandler.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import Foundation

public class JsonResponseHandler: ResponseHandler {
    
    private let decoder = JSONDecoder()
    
    public init() {}

    public func handle<T: Codable>(request: ApiRequest<T>,
                                   response: NetworkResponse,
                                   observer: @escaping (Result<T, ResponseErrorEntity>) -> Void) -> Bool {
        if let data = response.data {
            do {
                if T.self == Data.self {
                    observer(.success(data as! T))

                } else {
                    let result = try decoder.decode(T.self, from: data)
                    observer(.success(result))
                }
            } catch {
                let err = ResponseErrorEntity()
                err.errors.append(error.localizedDescription)
                observer(.failure(err))
            }
            return true
        }

        return false
    }

}
