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
    
    // MARK: - Flow Coordinators
    func makeProductsListFlowCoordinator(
        navigationController: UINavigationController) -> ProductsMainFlowCoordinator {
        return ProductsMainFlowCoordinator(
            navigationController: navigationController,
            dependencies: self)
    }
}

// MARK: - Use Cases & Repositories

extension ProductsSceneDIContainer {
    // MARK: - Use Cases
    
    func makeFetchProductsUseCase() -> FetchProductsUseCase {
        return DefaultFetchProductsUseCase(
            productsRepository: makeProductsRepository())
    }
    
    func makeFetchProductDetailsUseCase() -> FetchProductDetailsUseCase {
        return DefaultFetchProductDetailsUseCase(
            productDetailsRepository: makeProductDetailsRepository())
    }
    
    func makeFetchProductSecretUseCase() -> FetchProductSecretUseCase {
        return DefaultFetchProductSecretUseCase(
            productSecretRepository: makeProductSecretRepository())
    }
    
    func makeDeleteProductUseCase() -> DeleteProductUseCase {
        return DefaultDeleteProductDetailsUseCase(
            deleteProductRepository: makeDeleteProductRepository())
    }
    
    func makeEnrollProductUseCase() -> EnrollProductUseCase {
        return DefaultEnrollProductUseCase(
            enrollmentProductRepository: makeEnrollProductRepository())
    }
    
    func makeModifyProductsUseCase() -> ModifyProductsUseCase {
        return DefaultModifyProductsUseCase(
            modifyProductRepository: makeModifyProductRepository())
    }
    
    // MARK: Repositories
    
    func makeProductsRepository() -> ProductsRepository {
        return DefaultProductsRepository(
            dataTransferService: dependencies.apiDataTransferService)
    }
    
    func makeProductDetailsRepository() -> ProductDetailsRepository {
        return DefaultProductDetailsRepository(
            dataTransferService: dependencies.apiDataTransferService)
    }
    
    func makeProductSecretRepository() -> ProductSecretRepository {
        return DefaultProductSecretRepository(
            dataTransferService: dependencies.apiDataTransferService)
    }
    
    func makeDeleteProductRepository() -> DeleteProductRepository {
        return DefaultDeleteProductRepository(
            dataTransferService: dependencies.apiDataTransferService)
    }
    
    func makeEnrollProductRepository() -> DefaultEnrollProductRepository {
        return DefaultEnrollProductRepository(
            dataTransferService: dependencies.apiDataTransferService)
    }
    
    func makeModifyProductRepository() -> DefaultModifyProductRepository {
        return DefaultModifyProductRepository(
            dataTransferService: dependencies.apiDataTransferService)
    }
}

// MARK: - ViewModel & ViewController

extension ProductsSceneDIContainer {
    // MARK: - Products List
    func makeProductsListViewController(
        actions: ProductsListViewModelActions) -> ProductsListViewController {
        return ProductsListViewController(
            viewModel: makeProductsListViewModel(actions: actions))
    }
    
    func makeProductsListViewModel(
        actions: ProductsListViewModelActions) -> ProductsListViewModel {
        return DefaultProductsListViewModel(
            fetchProductsUseCase: makeFetchProductsUseCase(),
            actions: actions)
    }
    
    // MARK: - Product Details
    func makeProductDetailsViewController(
        product: ProductEntity,
        actions: ProductDetailsViewModelActions) -> ProductDetailsViewController {
        return ProductDetailsViewController(
            viewModel: makeProductDetailsViewModel(product: product,
                                                   actions: actions))
    }
    
    func makeProductDetailsViewModel(
        product: ProductEntity,
        actions: ProductDetailsViewModelActions) -> ProductDetailsViewModel {
        return DefaultProductDetailsViewModel(
            product: product,
            fetchProductDetailsUseCase: makeFetchProductDetailsUseCase(),
            fetchProductSecretUseCase: makeFetchProductSecretUseCase(),
            deleteProductUseCase: makeDeleteProductUseCase(),
            actions: actions)
    }
    
    // MARK: - Product Enrollment
    func makeProductsEnrollmentViewController(
        actions: ProductEnrollmentViewModelActions) -> ProductEnrollmentViewController {
        return ProductEnrollmentViewController(
            viewModel: makeProductEnrollmentViewModel(actions: actions))
    }
    
    func makeProductEnrollmentViewModel(
        actions: ProductEnrollmentViewModelActions) -> ProductEnrollmentViewModel {
        return DefaultProductEnrollmentViewModel(
            enrollmentProductsUseCase: makeEnrollProductUseCase(),
            actions: actions)
    }
    
    // MARK: Product Modification
    func makeProductModificationViewController(
        productDetails: ProductDetailsEntity,
        actions: ProductModificationViewModelActions) -> ProductModificationViewController {
        return ProductModificationViewController(
            viewModel: makeProductModificationViewModel(
                productDetails: productDetails,
                actions: actions))
    }
    
    func makeProductModificationViewModel(
        productDetails: ProductDetailsEntity,
        actions: ProductModificationViewModelActions) -> ProductModificationViewModel {
        return DefaultProductModificationViewModel(
            product: productDetails,
            motifyProductsUseCase: makeModifyProductsUseCase(),
            actions: actions)
    }
}

extension ProductsSceneDIContainer: ProductsMainFlowCoordinatorDependencies { }
