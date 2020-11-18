//
//  ExtendedApiRequest.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import Foundation

public class ExtendedApiRequest<T: Codable>: ApiRequest<T> {
    
    override public init(endpoint: ApiEndpoint) {
        super.init(endpoint: endpoint)
        super.responseTimeout = 30
    }

    override var request: URLRequest {
        var result = super.request
        result.timeoutInterval = self.responseTimeout
        return result
    }

    
    static func extendedRequest<T: Codable>(
            path: String? = nil,
            method: HttpMethod,
            endpoint: ApiEndpoint = ApiEndpoint.baseEndpoint,
            headers: [Header]? = nil,
            formData: FormDataFields? = nil,
            files: [UploadFile]? = nil,
            body: BodyConvertible? = nil,
            query: QueryField...) -> ExtendedApiRequest<T> {
        
        return ExtendedApiRequest
                    .extendedRequest(
                        path: path,
                        method: method,
                        endpoint: endpoint,
                        headers: headers,
                        formData: formData,
                        files: files,
                        body: body,
                        queryArr: query)
    }
    
    static func extendedRequest<T: Codable>(
            path: String? = nil,
            method: HttpMethod,
            endpoint: ApiEndpoint = ApiEndpoint.baseEndpoint,
            headers: [Header]? = nil,
            formData: FormDataFields? = nil,
            files: [UploadFile]? = nil,
            body: BodyConvertible? = nil,
            queryArr: [QueryField]) -> ExtendedApiRequest<T> {
        
        let request = ExtendedApiRequest<T>(endpoint: endpoint)
        request.path = path
        request.method = method
        request.headers = headers
        request.formData = formData
        request.files = files
        request.body = body
        request.query = queryArr
        return request
    }

}
