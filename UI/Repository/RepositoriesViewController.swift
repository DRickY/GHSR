//
//  ViewController.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import UIKit
import SwiftUI

class RepositoriesViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupSearchBar()
        self.setupTableView()
    }

    private func setupSearchBar() {
        let bar = self.searchBar
        self.view.addSubview(bar)
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.placeholder = "Search repositories on GitHub"
        bar.delegate = self
        
        NSLayoutConstraint.activate([
            self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: bar.topAnchor, constant: 0),
            bar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            bar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8)
        ])
        bar.sizeToFit()
    }
    
    private func setupTableView() {
        let tableView = self.tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.register(classes: RepositoryCell.self)
        
        tableView.tableFooterView = UIView()

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8)
        ])
    }
}

// MARK: - UITableViewDataSource

extension RepositoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: RepositoryCell.self, at: indexPath)
        
        if let c = cell as? RepositoryCell {
            c.fill(text: "Twitter запустив «Фліти» — свій аналог сторіз. Це зникаючі через 24 години публікації, Twitter запустив «Фліти» — свій аналог сторіз. Це зникаючі через 24 години публікації, Twitter запустив «Фліти, Twitter запустив «Фліти", description: "34432")
        }
        
        return cell
    }
    
    
}

// MARK: - UISearchBarDelegate

extension RepositoriesViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        print(#function)

    }

    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        searchBar.setShowsCancelButton(false, animated: true)

    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        bar.showsCancelButton = true
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        print("searched text \(searchBar.text)")
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.showsSearchResultsButton = true
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

