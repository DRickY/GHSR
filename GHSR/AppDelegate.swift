//
//  AppDelegate.swift
//  GHSR
//
//  Created by Dmytro.k on 11/16/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //        ApiEndpoint.baseEndpoint = ApiEndpoint(host: )
//        let client = ApiClientImpl.defaultInstance(host: Config.apiEndpoint)
//        client.responseHandlersQueue.append(JsonResponseHandler())
//        client.responseHandlersQueue.append(ErrorResponseHandler())
//        let api = ApiSearchRepositoriesGatewayImpl.init(client)
        
//        let g = RepositoriesPaginationImp(searchGateway: api)
        
//        self.g = g
        
//        g.loadNewData(searchBy: "swift") { (result) in
//            result.map {
//                print("OBSERVER IS PRINTER1  \($0.count)")
//                $0.forEach { v in
//                    print("ids \(v.id)")
//                }
//
//
//
//            }
//        }
        
        

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

