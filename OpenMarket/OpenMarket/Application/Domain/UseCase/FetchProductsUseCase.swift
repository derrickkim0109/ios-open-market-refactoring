//
//  FetchProductsUseCase.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/09.
//

import Foundation

protocol FetchProductsUseCase {
    func execute(requestValue: FetchProductsUseCaseRequestValue) async throws -> ProductsRequestDTO
}

final class DefaultFetchProductsUseCase: FetchProductsUseCase {
    private let productsRepository: ProductsRepository

    init(productsRepository: ProductsRepository) {
        self.productsRepository = productsRepository
    }

    func execute(requestValue: FetchProductsUseCaseRequestValue) async throws -> ProductsRequestDTO {
        return try await productsRepository.fetchProductsList(page: requestValue.page,
                                                              itemsPerPage: requestValue.itemPerPage)
    }
}

struct FetchProductsUseCaseRequestValue {
    let page: Int
    let itemPerPage: Int
}
