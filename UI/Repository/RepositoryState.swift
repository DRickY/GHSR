//
//  RepositoryState.swift
//  GHSR
//
//  Created by Dmytro.k on 11/23/20.
//

import Foundation

enum RepositoryAction: Action {
    case loading
    case loaded([RepositoryEntity])
    case errorWhileLoading(String)
    case searchRequest(String)
}

struct RepositoryState {
    let isLoading: Bool
    let repositories: [RepositoryEntity]
    let errorMessage: String?
    let searchField: String?
}

extension RepositoryState: Reducable {

    static var defaultValue = RepositoryState(isLoading: false,
                                              repositories: [],
                                              errorMessage: nil,
                                              searchField: nil)
    
    static func reducer(state: RepositoryState, action: RepositoryAction) -> RepositoryState {
        switch action {
        case .loading:
            return RepositoryState(isLoading: true,
                                   repositories: state.repositories,
                                   errorMessage: state.errorMessage,
                                   searchField: state.searchField)
            
        case .loaded(let values):
            let result = values
            return RepositoryState(isLoading: false,
                                   repositories: result,
                                   errorMessage: state.errorMessage,
                                   searchField: state.searchField)
            
        case .errorWhileLoading(let message):
            return RepositoryState(isLoading: false,
                                   repositories: state.repositories,
                                   errorMessage: message,
                                   searchField: state.searchField)
            
        case .searchRequest(let text):
            return RepositoryState(isLoading: state.isLoading,
                                   repositories: state.repositories,
                                   errorMessage: state.errorMessage,
                                   searchField: text)
        }
    }
}
