//
//  SceneDelegate.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let store = Store<AppState>.createStore()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        self.window = window
        window.rootViewController = self.configureVC()
        window.makeKeyAndVisible()
        
        let dispatch = self.store.dispatch
    }
    
    func configureVC() -> RepositoriesViewController {
//        let host = Config.apiEndpoint
//        let apiClient: ApiClient = ApiClientImpl.defaultInstance(host: host)
//        let gateway: SearchRepositoriesGateway = ApiSearchRepositoriesGatewayImpl(apiClient)
//
//        let paginator: RepositoriesPagination = RepositoriesPaginationImp(searchGateway: gateway)
        let vc = RepositoriesViewController()
//        let presenter = RepositoryPresenter(vc, paginator)
//        presenter.start()
       
        let render: (RepositoriesViewController.Props) -> () = { [weak view = vc] props in
            view?.props = props
        }
        
        let dispatch = self.store.dispatch
        
        let connector = RepositoryConnector(render: render,
                                            dispatch: dispatch)
        
        vc.deallocator = self.store.observe(observer: connector.present)
        
        return vc
    }
}

