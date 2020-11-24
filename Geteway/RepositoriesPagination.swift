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

    func hasMorePage() -> Bool
    
    func loadNewData(searchBy text: String, startLoading: (() -> Void)?, observer: @escaping (Result<[RepositoryEntity], Error>) -> Void)
    
    func reset()

    func reloadPage(text: String, from page: Int)
}

class RepositoriesPaginationImp: RepositoriesPagination {
    
    public var limit: Int = 15

    private var countItemsLastLoadedPage: Int = 0
    public var isLoadingInProcess: Bool = false

    private let searchGateway: SearchRepositoriesGateway

    private var currentPage = Atomic<Int>(value: 0)
    private var totalItemsCount: Int?
    private var items = [RepositoryEntity]()

    private var observer: ((Result<[RepositoryEntity], Error>) -> Void)?
    private var startLoading: (() -> Void)?
    
    private let currencyRequest = ConcurrencyRequests(maxConcurrentOperationCount: 2)
    
    private var nextPage: Int {
        return self.currentPage.mutate {
            let result = $0 + 1
            $0 = result
            return result
        }
    }

    init(searchGateway: SearchRepositoriesGateway) {
        self.searchGateway = searchGateway
    }

    public func hasMorePage() -> Bool {

        guard let totalItemsCount = self.totalItemsCount else {
            return true
        }

        return self.items.count < totalItemsCount
    }
    
    func perform(_ done: @escaping () -> Void) -> (Result<PaginationEntity<RepositoryEntity>, ResponseErrorEntity>) -> Void {
        return  { [weak self] (result) in
            
            switch result {
            case .success(let values):
//                self.currentPage += 1
                self?.totalItemsCount = values.totalItems
                self?.countItemsLastLoadedPage = values.items.count
                self?.items.append(contentsOf: values.items)
                self?.isLoadingInProcess = false
                
            case .failure(let error):
                self?.isLoadingInProcess = false
                DispatchQueue.main.async {
                    self?.observer?(.failure(error))
                }
                
                print("Pagination: catch error =", error.localizedDescription)
            }
            
            done()
        }
    }
        
    public func loadNewData(searchBy text: String, startLoading: (() -> Void)? = nil, observer: @escaping (Result<[RepositoryEntity], Error>) -> Void) {
        guard !self.isLoadingInProcess else {
            print("LOADING IN PROCESS")
            return }
        
        self.observer = observer
        self.startLoading = startLoading
        
        self.cancelLoading()
        self.isLoadingInProcess = true
        
        startLoading?()
        
        self.currencyRequest.executeGroup({ [weak self] done in
            guard let strongSelf = self else { return }
            strongSelf.searchGateway.searchRepositories(text: text,
                                                        currentPage: strongSelf.nextPage,
                                                        limit: strongSelf.limit,
                                                        strongSelf.perform(done))
        }, notify: .main, on: {
            self.observer?(.success(self.items))
        })
    }

    public func reset() {
        self.items.removeAll()
        self.totalItemsCount = nil
        self.currentPage = Atomic(value: 0)
        self.countItemsLastLoadedPage = 0
    }

    public func reloadPage(text: String, from page: Int) {
        let currentLoadedPage = self.currentPage.value == 1 ? 1 : self.currentPage.mutate {
            $0 = $0 - 1
            return $0
        }
        
        let itemsForRemove = self.countItemsLastLoadedPage + (currentLoadedPage - page) * self.limit
        self.items.removeLast(itemsForRemove)
        self.currentPage = Atomic(value: page)
        
        self.observer.map { self.loadNewData(searchBy: text, startLoading: self.startLoading, observer: $0) }
    }

    private func cancelLoading() {
    }
}
