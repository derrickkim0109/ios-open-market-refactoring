//
//  OpenMarket - SceneDelegate.swift
//  Created by 데릭, 수꿍. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let navigationController = UINavigationController()

        window?.rootViewController = navigationController
        appFlowCoordinator = AppFlowCoordinator(navigationController: navigationController,
                                                appDIContainer: appDIContainer)
        appFlowCoordinator?.start()

        window?.makeKeyAndVisible()
    }
}
