//
//  Requests.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import Foundation

public extension ExtendedApiRequest {
    static func serachRepositories(searchText: String,
                                   prePage: Int = 3,
                                   page: Int,
                                   sortBy: GitHubSort = .stars,
                                   order: GitHubOrder = .descending) -> ExtendedApiRequest
    {
        let queries = [QueryField(key: "q", value: searchText),
                       QueryField(key: "sort", value: sortBy.rawValue),
                       QueryField(key: "order", value: order.rawValue),
                       QueryField(key: "per_page", value: prePage.description),
                       QueryField(key: "page", value: page.description)]
        
        return self.extendedRequest(path: "/search/repositories", method: .get, headers: [.githubHeader], queryArr: queries)
    }
}
