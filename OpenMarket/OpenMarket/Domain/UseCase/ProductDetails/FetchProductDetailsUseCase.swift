//
//  FetchProductDetailsUseCase.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/10.
//

protocol FetchProductDetailsUseCase {
    func execute(productID: Int) async throws -> ProductDetailsEntity
}

final class DefaultFetchProductDetailsUseCase: FetchProductDetailsUseCase {
    private let productDetailsRepository: ProductDetailsRepository

    init(
        productDetailsRepository: ProductDetailsRepository) {
        self.productDetailsRepository = productDetailsRepository
    }

    func execute(
        productID: Int) async throws -> ProductDetailsEntity {
        return try await productDetailsRepository.fetchProductDetails(
            productID: productID)
    }
}
