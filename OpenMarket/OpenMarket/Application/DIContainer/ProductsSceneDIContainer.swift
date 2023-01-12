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

    func makeFetchProductDetailsUseCase() -> FetchProductDetailsUseCase {
        return DefaultFetchProductDetailsUseCase(productDetailsRepository: makeProductDetailsRepository())
    }

    func makeFetchProductSecretUseCase() -> FetchProductSecretUseCase {
        return DefaultFetchProductSecretUseCase(productSecretRepository: makeProductSecretRepository())
    }

    // MARK: - Repositories
    func makeProductsRepository() -> ProductsRepository {
        return DefaultProductsRepository(dataTransferService: dependencies.apiDataTransferService)
    }

    func makeProductDetailsRepository() -> ProductDetailsRepository {
        return DefaultProductDetailsRepository(dataTransferService: dependencies.apiDataTransferService)
    }

    func makeProductSecretRepository() -> ProductSecretRepository {
        return DefaultProductSecretRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    // MARK: - Products List
    func makeProductsListViewController(actions: ProductsListViewModelActions) -> ProductsListViewController {
        return ProductsListViewController(viewModel: makeProductsListViewModel(actions: actions))
    }

    func makeProductsListViewModel(actions: ProductsListViewModelActions) -> ProductsListViewModel {
        return DefaultProductsListViewModel(fetchProductsUseCase: makeFetchProductsUseCase(),
                                            actions: actions)
    }

    // MARK: - Product Details
    func makeProductDetailsViewController(product: ProductEntity,
                                          actions: ProductDetailsViewModelActions) -> ProductDetailsViewController {
        return ProductDetailsViewController(viewModel: makeProductDetailsViewModel(product: product,
                                                                                   actions: actions))
    }

    func makeProductDetailsViewModel(actions: ProductDetailsViewModelActions) -> ProductDetailsViewModel {
        return DefaultProductDetailsViewModel(fetchProductDetailsUseCase: makeFetchProductDetailsUseCase(),
    func makeProductDetailsViewModel(product: ProductEntity, actions: ProductDetailsViewModelActions) -> ProductDetailsViewModel {
        return DefaultProductDetailsViewModel(product: product,
                                              fetchProductDetailsUseCase: makeFetchProductDetailsUseCase(),
                                              fetchProductSecretUseCase: makeFetchProductSecretUseCase(),
                                              actions: actions)
    }

    // MARK: - Product Enrollment
    func makeProductsEnrollmentViewController() -> ProductEnrollmentViewController {
        return ProductEnrollmentViewController()
    }

    // MARK: - Flow Coordinators
    func makeProductsListFlowCoordinator(navigationController: UINavigationController) -> ProductsListFlowCoordinator {
        return ProductsListFlowCoordinator(navigationController: navigationController,
                                           dependencies: self)
    }
}

extension ProductsSceneDIContainer: ProductsListFlowCoordinatorDependencies { }
