//
//  FetchProductDetailsUseCase.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/10.
//

import Foundation

protocol FetchProductDetailsUseCase {
    func execute(productID: Int) async throws -> ProductDetailsRequestDTO
}

final class DefaultFetchProductDetailsUseCase: FetchProductDetailsUseCase {
    private let productDetailsRepository: ProductDetailsRepository

    init(productDetailsRepository: ProductDetailsRepository) {
        self.productDetailsRepository = productDetailsRepository
    }

    func execute(productID: Int) async throws -> ProductDetailsRequestDTO {
        return try await productDetailsRepository.fetchProductDetails(productID: productID)
    }
}
