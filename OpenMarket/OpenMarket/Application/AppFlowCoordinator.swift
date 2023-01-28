//
//  AppFlowCoordinator.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/07.
//

import UIKit

final class AppFlowCoordinator {
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let productsSceneDIContainer = appDIContainer.makeProductsSceneDIContainer()
        let flow = productsSceneDIContainer.makeProductsListFlowCoordinator(
            navigationController: navigationController)
        flow.start()
    }
}
