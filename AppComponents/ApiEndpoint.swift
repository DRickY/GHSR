//
//  ApiEndpoint.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import Foundation

public struct ApiEndpoint {
    
    public static var baseEndpoint: ApiEndpoint!

    let host: String
    
    init(host: String) {
        self.host = host
    }
}
