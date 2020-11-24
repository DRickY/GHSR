//
//  RepositoriesViewController+Setupable.swift
//  GHSR
//
//  Created by Dmytro.k on 11/23/20.
//

import UIKit

extension RepositoriesViewController {
    // MARK: - Init & Deinit
    
    func setupSearchBar() {
        let bar = self.searchBar
        self.view.addSubview(bar)
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.placeholder = "Search repositories on GitHub"
        bar.delegate = self
        
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: bar.topAnchor, constant: 0),
            bar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding),
            bar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -padding)
        ])
        bar.sizeToFit()
    }
    
    func setupTableView() {
        let tableView = self.tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.register(classes: RepositoryCell.self)
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -padding),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -padding)
        ])
    }
    
    func setupLoadingView() {
        let activityIndicator = self.loadingView
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicator)

        activityIndicator.style = .large
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    func setupErrorLabel(centerXAnchorConstant: CGFloat = 0, centerYAnchorConstant: CGFloat = 0) {
        let label = self.errorLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)

        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 55)
        label.numberOfLines = 0
        label.textAlignment = .center
            
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: centerXAnchorConstant),
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: centerYAnchorConstant),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor, constant: padding),
            label.trailingAnchor.constraint(greaterThanOrEqualTo: self.view.trailingAnchor, constant: -padding)
        ])
    }

}
