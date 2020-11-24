//
//  SearchMiddlewareEffect.swift
//  GHSR
//
//  Created by Dmytro.k on 11/23/20.
//

import Foundation

let searchMiddleware: Middleware<AppState> = createSideEffectMiddleware { (getState, dispatch) -> Dispatch in
    return { action in
        (action as? SearchEffect)?.handle(getState, dispatch)
    }
}

enum SearchEffect: Action {
    case newRequest(String)
}

extension SearchEffect {
    
    var pagination: RepositoriesPagination {
        let host = Config.apiEndpoint
        let apiClient: ApiClient = ApiClientImpl.defaultInstance(host: host)
        let gateway: SearchRepositoriesGateway = ApiSearchRepositoriesGatewayImpl(apiClient)

        let paginator: RepositoriesPagination = RepositoriesPaginationImp(searchGateway: gateway)
        return paginator
    }
    
    func handle(_ state: @escaping GetState<AppState>, _ dispatch: @escaping Dispatch) {
        
        let startLoading: () -> Void = {
            dispatch(RepositoryAction.loading)
        }
        
        let observer: (Result<[RepositoryEntity], Error>) -> Void = {(result) in
            switch result {
            case .success(let data):
                let action = RepositoryAction.loaded(data.sorted { $1.stars <= $0.stars })
                dispatch(action)

            case .failure(let error):
                dispatch(RepositoryAction.errorWhileLoading(error.localizedDescription))
            }
        }
        
        if case .newRequest(let text) = self {
            self.pagination.loadNewData(searchBy: text,
                                        startLoading: startLoading,
                                        observer: observer)

        }
    }

}
