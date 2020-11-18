//
//  SearchRepositoriesGateway.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import Foundation

public protocol SearchRepositoriesGateway {
    func searchRepositories(text: String, currentPage: Int, limit: Int, _ observer: @escaping (Result<PaginationEntity<RepositoryEntity>, ResponseErrorEntity>) -> Void)
}

public class ApiSearchRepositoriesGatewayImpl : ApiBaseGateway, SearchRepositoriesGateway {
    
    public func searchRepositories(text: String,
                                   currentPage: Int,
                                   limit: Int,
                                   _ observer: @escaping (Result<PaginationEntity<RepositoryEntity>, ResponseErrorEntity>) -> Void)
    {
        let request = ExtendedApiRequest<PaginationEntity<RepositoryEntity>>.serachRepositories(searchText: text,
                                                                                                prePage: limit,
                                                                                                page: currentPage)
        self.apiClient.execute(request: request, observer)
    }
    
}
