//
//  PaginationEntity.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import Foundation

public class PaginationEntity<T: Codable>: Codable {
    var totalItems: Int
//    var itemsPerPage: Int { 0 }
//    var countOfPages: Int {  }
    var items: [T]

    init(totalItems: Int, itemsPerPage: Int, countOfPages: Int, items: [T]) {
        self.totalItems = totalItems
//        self.itemsPerPage = itemsPerPage
//        self.countOfPages = countOfPages
        self.items = items
    }
    
    init(totalItems: Int, items: [T]) {
        self.totalItems = totalItems
        self.items = items
    }

    
    private enum CodingKeys : String, CodingKey {
        case totalItems = "total_count"
        case items = "items"
    }
}
