//
//  ProductsMainFlowCoordinator.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/08.
//

import UIKit

protocol ProductsMainFlowCoordinatorDependencies  {
    func makeProductsListViewController(actions: ProductsListViewModelActions) -> ProductsListViewController
    func makeProductsEnrollmentViewController() -> ProductEnrollmentViewController
    func makeProductDetailsViewController(product: ProductEntity,
                                          actions: ProductDetailsViewModelActions) -> ProductDetailsViewController
    func makeProductModificationViewController(productDetails: ProductDetailsEntity) -> ProductModificationViewController
}

final class ProductsMainFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: ProductsMainFlowCoordinatorDependencies

    private weak var productsListViewController: ProductsListViewController?

    init(navigationController: UINavigationController,
         dependencies: ProductsMainFlowCoordinatorDependencies) {
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

    private func presentProductModification(productDetails: ProductDetailsEntity) {
        let actions = ProductModificationViewModelActions(dismissViewController: dismissViewController)
        let viewController = dependencies.makeProductModificationViewController(productDetails: productDetails,
                                                                                actions: actions)

        let rootViewCntroller = UINavigationController(rootViewController: viewController)
        rootViewCntroller.modalPresentationStyle = .fullScreen
        navigationController?.present(rootViewCntroller, animated: true)
    }

    func dismissViewController() {
        Task {
            await MainActor.run() {
                self.navigationController?.dismiss(animated: true)
            }
        }
    }
}
