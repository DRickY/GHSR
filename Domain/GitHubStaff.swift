//
//  GitHubSort.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import Foundation

public enum GitHubSort: String {
    case stars, forks
    case helpWanted = "help-wanted-issues"
    case bestMatch = "best match"
}


public enum GitHubOrder: String {
    case ascending = "asc"
    case descending = "desc"
}
