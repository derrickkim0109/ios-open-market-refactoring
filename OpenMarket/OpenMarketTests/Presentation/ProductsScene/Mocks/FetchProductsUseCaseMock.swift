//
//  FetchProductsUseCaseMock.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/31.
//

import Foundation

final class FetchProductsUseCaseMock: FetchProductsUseCase {
    var error: Error?
    var products = ProductEntity.sample
    
    func execute(
        requestValue: FetchProductsUseCaseRequestValue) async throws -> [ProductEntity] {
            if error == nil {
                return products
            } else {
                throw error ?? DataTransferError.noResponse
            }
        }
}
