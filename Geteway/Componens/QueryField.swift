//
//  QueryField.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import Foundation

public struct QueryField {
    let key: String
    let value: String?
}

extension Array where Element == QueryField {    
    func toString() -> String {
        if !self.isEmpty {
            let flatStringQuery = self.filter({ $0.value?.isEmpty == false })
                .compactMap({ "\($0.key)=\($0.value!)" })
                .joined(separator: "&")
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            return "?\(flatStringQuery)"
        }
        
        return ""
    }
}
