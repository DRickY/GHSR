//
//  URLSessionProtocol.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import Foundation

public protocol URLSessionProtocol {

    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
