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
        window.rootViewController = RepositoriesViewController()
        window.makeKeyAndVisible()
    }
}

