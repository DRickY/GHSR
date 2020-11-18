//
//  ApiBaseGateway.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import Foundation

public class ApiBaseGateway {
    let apiClient: ApiClient
    
    init(_ client: ApiClient) {
        self.apiClient = client
    }
}
