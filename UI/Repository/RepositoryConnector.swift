//
//  RepositoryConnector.swift
//  GHSR
//
//  Created by Dmytro.k on 11/23/20.
//

import Foundation

struct RepositoryConnector {
    
    typealias Props = RepositoriesViewController.Props
    
    let render: (Props) -> Void // to view
    
    let dispatch: Dispatch // to Store, and async
    
    func present(state: AppState) {
        let props = self.stateToProps(state: state)
        self.render(props)
    }
    
    func stateToProps(state: AppState) -> Props {
        let repoState = state.repository
        
        let commandSearchDidTap = Command<Void> { [dispatcher = self.dispatch] in
            dispatcher(RepositoryAction.newSearch)
            dispatcher(RepositoryEffect.newRequest(text: repoState.searchField ?? "", limit: repoState.pageSize, page: 1))
        }
        
        let commandInputText = Command<String?> { [dispatcher = self.dispatch] input in
            dispatcher(RepositoryAction.textField(input ?? ""))
        }
                
        let commandCleanFieldDidTap = Command<(String?)> { [dispatcher = self.dispatch] text in
            dispatcher(RepositoryAction.textField(""))
        }
        
        let textField = Props.TextField(text: repoState.searchField,
                                        inputText: commandInputText,
                                        searchDidTap: commandSearchDidTap,
                                        cleanFieldDidTap: commandCleanFieldDidTap)
        
        if repoState.errorMessage == "" {
            return .error(repoState.errorMessage ?? "")
        } else if repoState.isLoading {
            return .loading
        } else if repoState.searchField != nil || repoState.searchField != "" {
            
            let commandNewBatch = Command<Void> { [dispatcher = self.dispatch] in
                    dispatcher(RepositoryEffect.newRequest(text: repoState.searchField ?? "",
                                                           limit: repoState.pageSize,
                                                           page: repoState.currentPage + 1))
            }
            
            let cells = repoState.repositories.map(RepositoryCell.Props.init)
            
            let result = Props.Data(pageSize: repoState.pageSize,
                                    data: cells,
                                    textField: textField,
                                    newBatch: commandNewBatch)

            return .repositories(result, textField)
            
        }
        
        return .initialValue
    }
}

fileprivate extension RepositoryCell.Props {
    init(entity: RepositoryEntity) {
        self.id = .init(value: entity.id.description)
        self.title = entity.title
        self.stars = entity.stars
    }
}
