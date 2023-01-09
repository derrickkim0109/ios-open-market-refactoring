//
//  ProductsSceneDIContainer.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/08.
//

import UIKit

final class ProductsSceneDIContainer {
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Use Cases
    func makeFetchProductsUseCase() -> FetchProductsUseCase {
        return DefaultFetchProductsUseCase(productsRepository: makeProductsRepository())
    }

    // MARK: - Repositories
    func makeProductsRepository() -> ProductsRepository {
        return DefaultProductsRepository(dataTransferService: dependencies.apiDataTransferService)
    }

    // MARK: - Products List
    func makeProductsListViewController(actions: ProductsListViewModelActions) -> ProductListViewController {
        return ProductListViewController(viewModel: makeProductsListViewModel(actions: actions))
    }

    func makeProductsListViewModel(actions: ProductsListViewModelActions) -> ProductsListViewModel {
        return DefaultProductsListViewModel(fetchProductsUseCase: makeFetchProductsUseCase(),
                                            actions: actions)
    }

    // MARK: - Product Enrollment
    func makeProductsEnrollmentViewController() -> ProductEnrollmentViewController {
        return ProductEnrollmentViewController()
    }

    // MARK: - Product Details
    func makeProductsDetailsViewController(product: ProductEntity) -> ProductDetailsViewController {
        return ProductDetailsViewController(model: product)
    }

    // MARK: - Flow Coordinators
    func makeProductsMainFlowCoordinator(navigationController: UINavigationController) -> ProductsMainFlowCoordinator {
        return ProductsMainFlowCoordinator(navigationController: navigationController,
                                           dependencies: self)
    }
}

extension ProductsSceneDIContainer: ProductsMainFlowCoordinatorDependencies { }
