//
//  RepositoryState.swift
//  GHSR
//
//  Created by Dmytro.k on 11/23/20.
//

import Foundation

enum RepositoryAction: Action {
    case loading(isLoading: Bool)
    case loaded([RepositoryEntity])
    case errorWhileLoading(String)
    case textField(String)
    case setCurrentPage(Int)
    case newSearch
    
//    case loaded(PaginationEntity)
}

struct RepositoryState {
    let isLoading: Bool
    let repositories: [RepositoryEntity]
    let errorMessage: String?
    let searchField: String?
    let currentPage: Int
    let pageSize: Int
    let totalItems: Int
    //    let repos: PaginationEntity
}

extension RepositoryState: Reducable {

    static var defaultValue = RepositoryState(isLoading: false,
                                              repositories: [],
                                              errorMessage: nil,
                                              searchField: nil,
                                              currentPage: 1,
                                              pageSize: 30,
                                              totalItems: 0)
    
    static func reducer(state: RepositoryState, action: RepositoryAction) -> RepositoryState {
        switch action {
        case .loading(let isLoading):
            return RepositoryState(isLoading: isLoading,
                                   repositories: state.repositories,
                                   errorMessage: state.errorMessage,
                                   searchField: state.searchField,
                                   currentPage: state.currentPage,
                                   pageSize: state.pageSize,
                                   totalItems: state.totalItems)
            
        case .loaded(let values):
            return RepositoryState(isLoading: state.isLoading,
                                   repositories: state.repositories + values,
                                   errorMessage: state.errorMessage,
                                   searchField: state.searchField,
                                   currentPage: state.currentPage,
                                   pageSize: state.pageSize,
                                   totalItems: state.totalItems)
            
        case .errorWhileLoading(let message):
            return RepositoryState(isLoading: state.isLoading,
                                   repositories: state.repositories,
                                   errorMessage: message,
                                   searchField: state.searchField,
                                   currentPage: state.currentPage,
                                   pageSize: state.pageSize,
                                   totalItems: state.totalItems)
            
        case .textField(let text):
            return RepositoryState(isLoading: state.isLoading,
                                   repositories: state.repositories,
                                   errorMessage: state.errorMessage,
                                   searchField: text,
                                   currentPage: state.currentPage,
                                   pageSize: state.pageSize,
                                   totalItems: state.totalItems)
            
        case .setCurrentPage(let p):
            return RepositoryState(isLoading: state.isLoading,
                                   repositories: state.repositories,
                                   errorMessage: state.errorMessage,
                                   searchField: state.searchField,
                                   currentPage: p,
                                   pageSize: state.pageSize,
                                   totalItems: state.totalItems)

        case .newSearch:
            return RepositoryState(isLoading: false,
                                   repositories: [],
                                   errorMessage: nil,
                                   searchField: state.searchField,
                                   currentPage: 1,
                                   pageSize: state.pageSize,
                                   totalItems: 0)
        }
    }
}
