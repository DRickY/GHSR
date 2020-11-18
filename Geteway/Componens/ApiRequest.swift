//
//  ApiRequest.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import Foundation

typealias FormDataFields = Dictionary<String, Any?>

open class ApiRequest<Response: Decodable>: NetworkRequest {
    
    var endpoint: ApiEndpoint
    var responseTimeout: Double = 10
    var query: [QueryField]?
    var path: String?
    var formData: FormDataFields?
    var headers: [Header]?
    var files: [UploadFile]?
    var method: HttpMethod?
    var body: BodyConvertible?
    

    private func bodyConstruction(_ request: inout URLRequest) {
        // Body construction
    }
    
    var request: URLRequest  {
        var request = URLRequest(url: URL(string: self.endpoint.host)!)
        request.httpMethod = self.method?.rawValue
        
        if let body = self.body {
            request.httpBody = body.createBody()
        } else {

            // Form data construction
            if (self.files == nil || self.files?.isEmpty == true), let formData = self.formData {
                request.httpBody = formData
                                    .compactMap { "\($0)=\($1 ?? "")" }
                                    .joined(separator: "&")
                                    .data(using: .utf8)
            }
            
            // SET FILES
            if let files = self.files {
                var body = Data()
                let boundary = UUID().uuidString
                
                files.forEach { (file) in
                    body.appendString("--\(boundary)\r\n")
                    body.appendString("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.name)\"\r\n")
                    body.appendString(("Content-Type: \(file.mimeType)\r\n\r\n"))
                    body.append(file.data)
                    body.appendString("\r\n")
                }
                
                if let formData = self.formData {
                    formData.forEach { key, value in
                        body.appendString("--\(boundary)\r\n")
                        body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                        body.appendString("\(value ?? "null")\r\n")

                    }
                }
                
                body.appendString("--\(boundary)--\r\n")
                request.setValue("multipart/form-data; boundary=\(boundary)",
                                 forHTTPHeaderField: "Content-Type")
                request.httpBody = body
            }

            if let headers = self.headers {
                request.allHTTPHeaderFields  = headers.toMap()
            }
            
            let endpointPart = self.endpoint.host
            let pathPart = self.path ?? ""
            let queryPart = self.query?.toString() ?? ""
            
            request.url = URL(string: endpointPart + pathPart + queryPart)
        }

        return request
    }

    init(endpoint: ApiEndpoint) {
        self.endpoint = endpoint
    }

    static func request<ResponseType: Codable>(path: String? = nil,
                                               method: HttpMethod,
                                               endpoint: ApiEndpoint = ApiEndpoint.baseEndpoint,
                                               headers: [Header]? = nil,
                                               formData: FormDataFields? = nil,
                                               files: [UploadFile]? = nil,
                                               body: BodyConvertible? = nil,
                                               query: QueryField...) -> ApiRequest<ResponseType>
    {
        let request = ApiRequest<ResponseType>(endpoint: endpoint)
        request.query = query
        request.path = path
        request.formData = formData
        request.headers = headers
        request.files = files
        request.method = method
        request.body = body
        
        return request
    }
    
}

fileprivate extension Data {

    mutating func appendString(_ string: String) {
        let data = string.data(using: .utf8, allowLossyConversion: false)
        self.append(data!)
    }
}
