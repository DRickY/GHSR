//
//  RepositoriesPagination.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import Foundation

protocol RepositoriesPagination {

    var limit: Int { get set }

    var isLoadingInProcess: Bool { get }

    var hasMorePage: Bool { get }
    
    func loadNewData(searchBy text: String, startLoading: (() -> Void)?, observer: @escaping (Result<[RepositoryEntity], Error>) -> Void)
    
    func reset()
}

class RepositoriesPaginationImp: RepositoriesPagination {
    
    public var limit: Int = 15

    public var isLoadingInProcess: Bool = false
    
    public var hasMorePage: Bool {
        guard let totalItemsCount = self.totalItemsCount else {
            return true
        }

        return (self.countItemsLastLoadedPage * self.currentPage) < totalItemsCount
    }

    private var countItemsLastLoadedPage: Int = 0

    private let searchGateway: SearchRepositoriesGateway

    private var currentPage = 0
    
    private var totalItemsCount: Int?

    private var observer: ((Result<[RepositoryEntity], Error>) -> Void)?
    
    private var startLoading: (() -> Void)?
    
    private var nextPage: Int {
        let result = self.currentPage + 1
        self.currentPage = result

        return result
    }

    init(searchGateway: SearchRepositoriesGateway) {
        self.searchGateway = searchGateway
    }

        
    public func loadNewData(searchBy text: String,
                            startLoading: (() -> Void)? = nil,
                            observer: @escaping (Result<[RepositoryEntity], Error>) -> Void)
    {
        guard !self.isLoadingInProcess else { return }
        
        self.observer = observer
        self.startLoading = startLoading
        
        self.cancelLoading()
        self.isLoadingInProcess = true
        
        startLoading?()
        
        let resultObserver: (Result<PaginationEntity<RepositoryEntity>, ResponseErrorEntity>) -> Void = { [weak self] (result) in
            switch result {
            case .success(let values):
                print("ger items counts \(values.items.count)")
                self?.totalItemsCount = values.totalItems
                self?.countItemsLastLoadedPage = values.items.count
                self?.isLoadingInProcess = false
//            self?.observer?(.success(self.items))

            case .failure(let error):
                self?.isLoadingInProcess = false
                DispatchQueue.main.async {
                    self?.observer?(.failure(error))
                }
                
                print("Pagination: catch error =", error.localizedDescription)
            }
        }
        
        self.searchGateway.searchRepositories(text: text,
                                              page: self.nextPage,
                                              limit: self.limit,
                                              observer: resultObserver)
    }

    public func reset() {
        self.totalItemsCount = nil
        self.currentPage = 0
        self.countItemsLastLoadedPage = 0
    }

    private func cancelLoading() {
    }
}
