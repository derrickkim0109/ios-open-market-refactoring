//
//  ModifyProductsUseCase.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/10.
//

import Foundation

protocol ModifyProductsUseCase {
    func execute(productID: Int, product: TypedProductDetailsRequestDTO) async throws 
}

final class DefaultModifyProductsUseCase: ModifyProductsUseCase {
    private let modifyProductRepository: ModifyProductRepository

    init(modifyProductRepository: ModifyProductRepository) {
        self.modifyProductRepository = modifyProductRepository
    }

    func execute(productID: Int, product: TypedProductDetailsRequestDTO) async throws  {
        return try await modifyProductRepository.modifyProduct(productID: productID, product: product)
    }
}
