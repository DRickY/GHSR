//
//  AppState.swift
//  GHSR
//
//  Created by Dmytro.k on 11/20/20.
//

import Foundation

struct AppState {
    let repository: RepositoryState
    
    static func reducer(state: AppState, action: Action) -> AppState {
        switch action {
        case let action as RepositoryAction:
            return AppState(repository: .reducer(state: state.repository, action: action))
        default: return state
        }
    }
}

extension AppState: Defaultable {
    static var defaultValue = AppState(repository: .defaultValue)
}
