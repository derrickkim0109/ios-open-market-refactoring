//
//  ProductsMainFlowCoordinator.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/08.
//

import UIKit

protocol ProductsMainFlowCoordinatorDependencies  {
    func makeProductsListViewController(actions: ProductsListViewModelActions) -> ProductListViewController
    func makeProductsEnrollmentViewController() -> ProductEnrollmentViewController
    func makeProductsDetailsViewController(product: ProductEntity) -> ProductDetailsViewController
}

final class ProductsMainFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: ProductsMainFlowCoordinatorDependencies

    private weak var productsListViewController: ProductListViewController?

    init(navigationController: UINavigationController,
         dependencies: ProductsMainFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let actions = ProductsListViewModelActions(showProductEnrollment: showProductEnrollment,
                                                   showProductDetails: showProductDetails)
        let viewController = dependencies.makeProductsListViewController(actions: actions)

        navigationController?.pushViewController(viewController, animated: false)
        productsListViewController = viewController
    }

    private func showProductDetails(product: ProductEntity) {
        let viewController = dependencies.makeProductsDetailsViewController(product: product)
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func showProductEnrollment() {
        let viewController = dependencies.makeProductsEnrollmentViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
