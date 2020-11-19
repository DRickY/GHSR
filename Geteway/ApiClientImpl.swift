//
//  ApiClientImpl.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import Foundation

class ApiClientImpl: ApiClient {

    private let urlSession: URLSessionProtocol
    
    var interceptors: [Interceptor] = []
    
    var responseHandlersQueue: [ResponseHandler] = []

    public init(urlSessionConfiguration: URLSessionConfiguration, queue: OperationQueue) {
        self.urlSession = URLSession(configuration: urlSessionConfiguration,
                                     delegate: nil, delegateQueue: queue)
    }
    
    public init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }
    
    func execute<T: Codable>(request: ApiRequest<T>, _ callback: @escaping (Result<T, ResponseErrorEntity>) -> Void) {
        self.prepare(request: request)
        
        let dataTask = self.urlSession.dataTask(with: request.request,
                                                completionHandler: self.networkBlock(request: request, callback))
        dataTask.resume()
    }
    
    private func networkBlock<T: Codable>(request: ApiRequest<T>,
                                          _ callback: @escaping (Result<T, ResponseErrorEntity>) -> Void)
    -> (Data?, URLResponse?, Error?) -> ()
    {
        return { (data: Data?, response: URLResponse?, error: Error?) in
            self.preHandle(request: request, response: (data, response, error))
            
            var isHandled = false
            
            for handler in self.responseHandlersQueue {
                if isHandled { break }
                
                isHandled = handler.handle(request: request,
                                           response: (data, response, error),
                                           observer: callback)
            }
            
            if !isHandled {
                var errorEntity = ResponseErrorEntity(response)
                errorEntity.errors.append(
                        "Internal application error: server response handler not found")
                callback(.failure(errorEntity))
            }
        }
    }
    
    private func prepare<T: Codable>(request: ApiRequest<T>) {
        self.interceptors.forEach {
            $0.prepare(request: request)
        }
    }
    
    private func preHandle<T: Codable>(request: ApiRequest<T>, response: NetworkResponse) {
        self.interceptors.forEach {
            $0.handle(request: request, response: response)
        }
    }
    
    public static func defaultInstance(host: String) -> ApiClient {
        ApiEndpoint.baseEndpoint = ApiEndpoint(host: host)
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration)
        let client = ApiClientImpl(urlSession: session)
        client.responseHandlersQueue.append(ErrorResponseHandler())
        client.responseHandlersQueue.append(JsonResponseHandler())
        
        return client
    }
}
