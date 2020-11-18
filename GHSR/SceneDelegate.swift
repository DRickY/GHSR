//
//  SceneDelegate.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        self.window = window
        window.rootViewController = self.configureVC()
        window.makeKeyAndVisible()
    }
    
    func configureVC() -> RepositoriesViewController {
        let host = Config.apiEndpoint
        let apiClient: ApiClient = ApiClientImpl.defaultInstance(host: host)
        let gateway: SearchRepositoriesGateway = ApiSearchRepositoriesGatewayImpl(apiClient)

        let paginator: RepositoriesPagination = RepositoriesPaginationImp(searchGateway: gateway)
//        RepositoriesPagination
        let vc = RepositoriesViewController()
        let presenter = RepositoryPresenter(vc, paginator)
        presenter.start()
        vc.deallocator = Deallocator({ presenter })
        
        return vc
    }
}

