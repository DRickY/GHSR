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
        case error(String, newRequest: Command<String?>)
        case hasNotText(Command<String?>)
        case repositories(Data)
        
        struct Data {
            let data: [RepositoryCell.Props]
            let loadMore: Command<Void>
            let searchRepository: Command<String?>
            let cancel: Command<Void>
        }
        
        static var initial: Props { Props.initialValue }
    }
}

class RepositoriesViewController: UIViewController, RepositoriesView {
    
    // MARK: - Properties
    
    private lazy var searchBar = UISearchBar()
    
    private lazy var tableView = UITableView()
    
    private lazy var loadingView = UIActivityIndicatorView()
    
    private lazy var errorLabel = UILabel()
    
    var props: RepositoriesViewController.Props = .initial {
        didSet { self.view.setNeedsLayout() }
    }
    
    var deallocator: Deallocator?

    // MARK: - Init & Deinit
    
    private func setupSearchBar() {
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
    
    private func setupTableView() {
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
    
    private func setupLoadingView() {
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
    
    private func setupErrorLabel(centerXAnchorConstant: CGFloat = 0, centerYAnchorConstant: CGFloat = 0) {
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
        self.render(props: self.props)
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

        case .error(let errorData, _):
            self.searchBar.isHidden = false
            self.tableView.isHidden = true
            self.loadingView.stopAnimating()
            self.errorLabel.isHidden = false
            self.errorLabel.text = errorData.description
            self.errorLabel.sizeToFit()
        case .hasNotText:
            self.searchBar.isHidden = false
            self.tableView.isHidden = true
            self.loadingView.stopAnimating()
            self.errorLabel.isHidden = true

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
        if case .repositories(let data) = self.props {
            return data.data.count
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: RepositoryCell.self, at: indexPath)
        
        if case .repositories(let repos) = self.props,
           let data = repos.data[safe: indexPath.row]
        {
            if indexPath.row >= repos.data.count - 1 {
                print("IP=\(indexPath.row), count-1 =\(repos.data.count - 1)")
                repos.loadMore.execute()
            }
            
            if let c = cell as? RepositoryCell {
                c.fill(props: data)
            }
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
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
        if case .repositories(let data) = self.props {
            searchBar.clear()
            data.cancel.execute()
        }
        
        if case .hasNotText(_) = self.props {
            searchBar.clear()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if case .hasNotText(let command) = self.props {
            command.execute(with: searchBar.text)
        }

        if case .repositories(let data) = self.props {
            data.searchRepository.execute(with: searchBar.text)
        }
        
        
        if case .error(_, newRequest: let command) = self.props {
            command.execute(with: searchBar.text)
        }

        
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

