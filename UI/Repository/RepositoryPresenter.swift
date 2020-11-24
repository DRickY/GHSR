//
//  RepositoryPresenter.swift
//  GHSR
//
//  Created by Dmytro.k on 11/17/20.
//

import Foundation

final class RepositoryPresenter {
    
    private weak var view: RepositoriesView?
    
    private var isLoading = false
    private let limitPagination: Int
    private var pagination: RepositoriesPagination
    private var searchText: String?
    private var data = [RepositoryEntity]()
    
    init(_ view: RepositoriesView, _ pagination: RepositoriesPagination) {
        self.view = view
        self.pagination = pagination

        self.limitPagination = 15
        self.pagination.limit = self.limitPagination
    }
        
    private func stateToProps(error: Swift.Error? = nil) {
//        if self.searchText == nil || self.searchText == "" {
//            self.view?.props = .hasNotText(Command<String?> { text in
//                self.searchRepository(by: text)
//            })
//        } else if let e = error {
//            self.view?.props = .error(e.localizedDescription)
//
//        } else if self.data.count > 0 {
//            let cells = self.data.map(RepositoryCell.Props.init)
//
//            let localData = RepositoriesViewController.Props.Data(data: cells,
//                                                                  loadMore: Command<Void> {
//                                                                    if !self.isLoading {
//                                                                        print("BEGIN SEARCH NEW")
//                                                                        self.loadNewRepositoies()
//                                                                    }
//                                                                  },
//                                                                  searchRepository: Command<String?> { text in
//                                                                    self.searchRepository(by: text)
//                                                                  },
//                                                                  cancel: Command<Void> {
//                                                                    self.reset()
//                                                                    self.reloadData()
//                                                                  })
//
//            self.view?.props = .repositories(localData)
//        } else if self.isLoading {
//            self.view?.props = .loading
//        }
    }
    
    func start() {
        self.reloadData()
    }

    private func reloadData() {
        self.pagination.reset()
        self.loadNewRepositoies()
    }
    
    private func reset() {
        self.searchText = nil
        self.isLoading = false
        self.data = []
        self.pagination.reset()
    }
    
    private func loadNewRepositoies() {
        guard let text = self.searchText, text != "" else {
            self.stateToProps()
            return
        }
        
//        guard self.pagination.hasMorePage(), !self.isLoading else { return }
        
//        self.pagination.loadNewData(searchBy: text,
//                                    startLoading: { [weak self] in
//                                        self?.isLoading = true
//                                        self?.stateToProps()
//                                    },
//                                    observer: { [weak self] (result) in
//                                        switch result {
//                                        case .success(let data):
//                                            let result = data.sorted { $1.stars <= $0.stars }
//                                            self?.data = result
//                                            self?.stateToProps()
//
//                                        case .failure(let error):
//                                            self?.stateToProps(error: error)
//                                            self?.data = []
//                                            self?.pagination.reset()
//                                        }
//                                        self?.isLoading = false
//                                    })
    }
        
    private func searchRepository(by text: String?) {
        
        let newValue = text!.count < 2 ? nil : text
        
        if self.searchText != newValue {
            self.searchText = newValue
            self.reloadData()
        }
    }
}

fileprivate extension RepositoryCell.Props {
    init(entity: RepositoryEntity) {
        self.id = .init(value: entity.id.description)
        self.title = entity.title
        self.stars = entity.stars
    }
}

