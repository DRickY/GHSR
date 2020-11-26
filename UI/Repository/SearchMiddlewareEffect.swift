//
//  SearchMiddlewareEffect.swift
//  GHSR
//
//  Created by Dmytro.k on 11/23/20.
//

import Foundation

let searchMiddleware: Middleware<AppState> = createSideEffectMiddleware { (getState, dispatch) -> Dispatch in
    return { action in
        (action as? RepositoryEffect)?.handle(getState, dispatch)
    }
}

enum RepositoryEffect: Action {
    case newRequest(text: String, limit: Int, page: Int)
}

extension RepositoryEffect {
    
    var pagination: RepositoriesPagination {
        let host = Config.apiEndpoint
        let apiClient: ApiClient = ApiClientImpl.defaultInstance(host: host)
        let gateway: SearchRepositoriesGateway = ApiSearchRepositoriesGatewayImpl(apiClient)

        let paginator: RepositoriesPagination = RepositoriesPaginationImp(searchGateway: gateway)
        return paginator
    }
    
    var p: SearchRepositoriesGateway {
        let host = Config.apiEndpoint
        let apiClient: ApiClient = ApiClientImpl.defaultInstance(host: host)

        return ApiSearchRepositoriesGatewayImpl(apiClient)
    }
    
    func handle(_ getState: @escaping GetState<AppState>, _ dispatch: @escaping Dispatch) {

        guard let state = getState(), !state.repository.isLoading else {
            NSLog("GetState No LoadNew Data")

            return
        }

        dispatch(RepositoryAction.loading(isLoading: true))
        
        if case let .newRequest(text, lim, page) = self {
            NSLog("LOAD NEW Batch PAGINATION at page: \(page)")
            self.p.searchRepositories(text: text,
                                      page: page,
                                      limit: lim) { (result) in
                switch result {
                case .success(let data):
                    print("data -")
                    dispatch(RepositoryAction.setCurrentPage(page))
                    dispatch(RepositoryAction.loading(isLoading: false))
                    let action = RepositoryAction.loaded(data.items.sorted { $1.stars <= $0.stars })
                    dispatch(action)

                case .failure(let error):
                    print("error \(error)")
                    dispatch(RepositoryAction.errorWhileLoading(error.localizedDescription))
                }
            }
        }
    }

}
