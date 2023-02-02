//
//  ProductsMainFlowCoordinator.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/08.
//

import UIKit

protocol ProductsMainFlowCoordinatorDependencies  {
    func makeProductsListViewController(
        actions: ProductsListViewModelActions) -> ProductsListViewController
    func makeProductsEnrollmentViewController(
        actions: ProductEnrollmentViewModelActions) -> ProductEnrollmentViewController
    func makeProductDetailsViewController(
        product: ProductEntity,
        actions: ProductDetailsViewModelActions) -> ProductDetailsViewController
    func makeProductModificationViewController(
        productDetails: ProductDetailsEntity,
        actions: ProductModificationViewModelActions) -> ProductModificationViewController
}

final class ProductsMainFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: ProductsMainFlowCoordinatorDependencies
    
    private weak var productsListViewController: ProductsListViewController?
    private let bag = AnyCancelTaskBag()
    
    init(
        navigationController: UINavigationController,
        dependencies: ProductsMainFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = ProductsListViewModelActions(
            presentProductEnrollment: presentProductEnrollment,
            presentProductDetails: presentProductDetails)

        let viewController = dependencies.makeProductsListViewController(
            actions: actions)
        
        navigationController?.pushViewController(
            viewController,
            animated: false)

        productsListViewController = viewController
    }
    
    private func presentProductDetails(
        product: ProductEntity) {
        let actions = ProductDetailsViewModelActions(
            presentProductModitifation: presentProductModification,
            popViewController: popViewController)

        let viewController = dependencies.makeProductDetailsViewController(
            product: product,
            actions: actions)

        navigationController?.pushViewController(
            viewController,
            animated: true)
    }
    
    private func presentProductEnrollment() {
        let actions = ProductEnrollmentViewModelActions(
            dismissViewController: dismissViewController)
        let viewController = dependencies.makeProductsEnrollmentViewController(
            actions: actions)
        
        let rootViewCntroller = UINavigationController(
            rootViewController: viewController)

        rootViewCntroller.modalPresentationStyle = .fullScreen

        navigationController?.present(
            rootViewCntroller,
            animated: true)
    }
    
    private func presentProductModification(
        productDetails: ProductDetailsEntity) {
        let actions = ProductModificationViewModelActions(
            dismissViewController: dismissViewController)

        let viewController = dependencies.makeProductModificationViewController(
            productDetails: productDetails,
            actions: actions)
        
        let rootViewCntroller = UINavigationController(
            rootViewController: viewController)
            
        rootViewCntroller.modalPresentationStyle = .fullScreen

        navigationController?.present(
            rootViewCntroller,
            animated: true)
    }
    
    private func popViewController() {
        Task {
            await MainActor.run() {
                navigationController?.popViewController(
                    animated: true)
            }
        }.store(in: bag)
    }

    private func dismissViewController() {
        Task {
            await MainActor.run() {
                navigationController?.dismiss(
                    animated: true)
            }
        }.store(in: bag)
    }
}
