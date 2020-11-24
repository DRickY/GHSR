//
//  RepositoriesViewController+Renderable.swift
//  GHSR
//
//  Created by Dmytro.k on 11/23/20.
//

import UIKit
/*
 enum Props {
     case initialValue
     case loading
     case error(String)
     case hasNotText(Command<String?>) // firstRequest
     case repositories(Data)
     
     struct Data {
         let data: [RepositoryCell.Props]
         let loadMore: Command<Void>
         let searchRepository: Command<String?>
         let cancel: Command<Void>
     }
     
     static var initial: Props { Props.initialValue }
 }
 */
extension RepositoriesViewController {
    
    func render2(props: Props) {
        switch props {
        case .initialValue:
            self.searchBar.isHidden = true
            self.tableView.isHidden = true
            self.loadingView.stopAnimating()
            self.errorLabel.isHidden = true
        case .loading:
            self.searchBar.isHidden = true
            self.tableView.isHidden = true
            self.loadingView.startAnimating()
            self.errorLabel.isHidden = true
            
        case .error:
            self.searchBar.isHidden = false
            self.tableView.isHidden = true
            self.loadingView.stopAnimating()
            self.errorLabel.isHidden = false
            //            self.errorLabel.text = errorData.description
            self.errorLabel.sizeToFit()
//        case .hasNotText(let value):
//            self.searchBar.isHidden = false
//            self.tableView.isHidden = true
//            self.loadingView.stopAnimating()
//            self.errorLabel.isHidden = true
            
//            self.searchBar.text = value.text
//            //
//            if value.text.isNil || value.text == "" {
//                self.searchBar.resignFirstResponder()
//                self.searchBar.setShowsCancelButton(value.text.isNil, animated: true)
//                self.searchBar.showsSearchResultsButton = value.text.isNil
//
//            } else {
//                self.searchBar.becomeFirstResponder()
//                self.searchBar.setShowsCancelButton(!value.text.isNil, animated: true)
//                self.searchBar.showsSearchResultsButton = !value.text.isNil
//            }
            
        case let .repositories(values, field):
            self.searchBar.isHidden = false
            self.errorLabel.isHidden = true
            self.loadingView.stopAnimating()
            self.tableView.isHidden = values.data.isEmpty
            self.tableView.reloadData()
            
            self.searchBar.text = field.text
            //
            if field.text.isNil || field.text == "" {
                self.searchBar.resignFirstResponder()
                self.searchBar.setShowsCancelButton(field.text.isNil, animated: true)
                self.searchBar.showsSearchResultsButton = field.text.isNil
                
            } else {
                self.searchBar.becomeFirstResponder()
                self.searchBar.setShowsCancelButton(!field.text.isNil, animated: true)
                self.searchBar.showsSearchResultsButton = !field.text.isNil
            }

            
        }
    }
}
