//
//  RepositoriesPagination.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import Foundation

protocol RepositoriesPagination {

//    var limit: Int { get set }

//    var isLoadingInProcess: Bool { get }

//    var hasMorePage: Bool { get }
    
    func loadNewData(searchBy text: String, startLoading: (() -> Void)?, observer: @escaping (Result<[RepositoryEntity], Error>) -> Void)
    
    func reset()
}

class RepositoriesPaginationImp: RepositoriesPagination {

    private let searchGateway: SearchRepositoriesGateway

    private var observer: ((Result<[RepositoryEntity], Error>) -> Void)?
    
    private var startLoading: (() -> Void)?

    init(searchGateway: SearchRepositoriesGateway) {
        self.searchGateway = searchGateway
    }

    public func loadNewData(searchBy text: String,
                            startLoading: (() -> Void)? = nil,
                            observer: @escaping (Result<[RepositoryEntity], Error>) -> Void)
    {
        self.observer = observer
        self.startLoading = startLoading
        
        self.cancelLoading()
        
        startLoading?()
        
        let resultObserver: (Result<PaginationEntity<RepositoryEntity>, ResponseErrorEntity>) -> Void = { [weak self] (result) in
            switch result {
            case .success(let values):
                print("ger items counts \(values.items.count)")
//            self?.observer?(.success(self.items))

            case .failure(let error):
                DispatchQueue.main.async {
                    self?.observer?(.failure(error))
                }
                
                print("Pagination: catch error =", error.localizedDescription)
            }
        }
        
        self.searchGateway.searchRepositories(text: text,
                                              page: 0,
                                              limit: 0,
                                              observer: resultObserver)
    }

    public func reset() {

    }

    private func cancelLoading() {
    }
}
