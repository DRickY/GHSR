//
//  RepositoryEntity.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import Foundation

public struct RepositoryEntity: Codable {
    let id: Int
    let title: String
    let stars: Int
    
    private enum CodingKeys : String, CodingKey {
        case id = "id"
        case title = "full_name"
        case stars = "stargazers_count"
    }
}
