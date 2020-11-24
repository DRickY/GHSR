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
        let s = state.repository
        
        let commandInputText = Command<String?> { [dispatcher = self.dispatch] text in
            dispatcher(RepositoryAction.searchRequest(text ?? ""))
        }
        
        let commandSearchDidTap = Command<Void> { [dispatcher = self.dispatch] in
            dispatcher(SearchEffect.newRequest(s.searchField ?? ""))
        }
        
        let commandCleanFieldDidTap = Command<(String?)> { [dispatcher = self.dispatch] text in
            dispatcher(RepositoryAction.searchRequest(""))
        }
        
        let textField = Props.TextField(text: s.searchField,
                                        inputText: commandInputText,
                                        searchDidTap: commandSearchDidTap,
                                        cleanFieldDidTap: commandCleanFieldDidTap)
        
        if s.errorMessage == "" {
            return .error(s.errorMessage ?? "")
        } else if s.isLoading {
            return .loading
        } else if s.searchField != nil || s.searchField != "" {
            
            let commandNewBatch = Command<Void> { [dispatcher = self.dispatch] in
                print("BEGIN SEARCH NEW")
            }
            
            let cells = s.repositories.map(RepositoryCell.Props.init)
            
            let result = Props.Data(data: cells,
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
