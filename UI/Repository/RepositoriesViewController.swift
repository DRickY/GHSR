//
//  ViewController.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import UIKit
import SwiftUI

protocol RepositoriesView: AnyObject {
    var props: RepositoriesViewController.Props { get set }
}

extension RepositoriesViewController {
    enum Props {
        case initialValue
        case loading
        case repositories(Data, TextField)
        case error(String)
        
        struct TextField {
            let text: String? // value changes while typing text
            let inputText: Command<String?> // output current text symbols to store
            let searchDidTap: Command<Void> // search button didTap.
            
            let cleanFieldDidTap: Command<(String?)> // hide cancel button and clear text
        }
        
        struct Data {
            let data: [RepositoryCell.Props]
            let textField: TextField
            let newBatch: Command<Void>
        }
    }
}

class RepositoriesViewController: UIViewController, RepositoriesView {
    
    // MARK: - Properties
    
    private(set) lazy var searchBar = UISearchBar()
    
    private(set) lazy var tableView = UITableView()
    
    private(set) lazy var loadingView = UIActivityIndicatorView()
    
    private(set) lazy var errorLabel = UILabel()
    
    var props: RepositoriesViewController.Props = .initialValue {
        didSet { self.view.setNeedsLayout() }
    }
    
    var deallocator: Deallocator?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupSearchBar()
        self.setupTableView()
        self.setupLoadingView()
        self.setupErrorLabel()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.render2(props: self.props)
    }
}

fileprivate extension RepositoriesViewController {
    func render(props: Props) {
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
//        case .hasNotText:
//            self.searchBar.isHidden = false
//            self.tableView.isHidden = true
//            self.loadingView.stopAnimating()
//            self.errorLabel.isHidden = true

        case .repositories:
            self.searchBar.isHidden = false
            self.tableView.isHidden = false
            self.tableView.reloadData()
            self.loadingView.stopAnimating()
            self.errorLabel.isHidden = true
        }
    }
}

// MARK: - UITableViewDataSource

extension RepositoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if case .repositories(let data, _) = self.props {
            return data.data.count
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(with: RepositoryCell.self, at: indexPath) { (c) in
            if case .repositories(let repos, _) = self.props,
               let data = repos.data[safe: indexPath.row]
            {
                if indexPath.row >= repos.data.count - 1 {
                    repos.newBatch.execute()
                }
                
                c.fill(props: data)
            }
        }
    }
}

// MARK: - UISearchBarDelegate
// Massive
extension RepositoriesViewController: UISearchBarDelegate {
//    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//        searchBar.setShowsCancelButton(true, animated: true)
//        return true
//    }
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchBar.setShowsCancelButton(false, animated: true)
//    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if case .hasNotText(let textField) = self.props {
//            textField.inputText.execute(with: searchText)
//        }

        if case let .repositories(data, field) = self.props {
            data.textField.inputText.execute(with: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if case let .repositories(data, field) = self.props {
            data.textField.cleanFieldDidTap.execute(with: searchBar.text)
        }
        
//        if case .hasNotText(let textfield) = self.props {
//            textfield.cleanFieldDidTap.execute(with: searchBar.text)
//        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if case .hasNotText(let textField) = self.props {
//            textField.searchDidTap.execute()
//        }

        if case let .repositories(data, field) = self.props {
            data.textField.searchDidTap.execute()
        }
    }
}


#if canImport(SwiftUI) && targetEnvironment(simulator) && DEBUG
class PreviewUIViewController: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewControllerPreview {
                RepositoriesViewController()
            }
        }
    }
}
#endif

