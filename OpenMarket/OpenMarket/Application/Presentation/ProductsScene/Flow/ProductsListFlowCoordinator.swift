//
//  ProductsListFlowCoordinator.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/08.
//

import UIKit

protocol ProductsListFlowCoordinatorDependencies  {
    func makeProductsListViewController(actions: ProductsListViewModelActions) -> ProductsListViewController
    func makeProductsEnrollmentViewController() -> ProductEnrollmentViewController
    func makeProductDetailsViewController(product: ProductEntity,
                                          actions: ProductDetailsViewModelActions) -> ProductDetailsViewController
}

final class ProductsListFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: ProductsListFlowCoordinatorDependencies

    private weak var productsListViewController: ProductsListViewController?

    init(navigationController: UINavigationController,
         dependencies: ProductsListFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let actions = ProductsListViewModelActions(presentProductEnrollment: presentProductEnrollment,
                                                   presentProductDetails: presentProductDetails)
        let viewController = dependencies.makeProductsListViewController(actions: actions)

        navigationController?.pushViewController(viewController, animated: false)
        productsListViewController = viewController
    }

    private func presentProductDetails(product: ProductEntity) {
        let actions = ProductDetailsViewModelActions(presentProductModitifation: presentProductModification)
        let viewController = dependencies.makeProductDetailsViewController(product: product,
                                                                           actions: actions)
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func presentProductEnrollment() {
        let viewController = dependencies.makeProductsEnrollmentViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func presentProductModification(model: ProductDetailsEntity) {

    }
}
