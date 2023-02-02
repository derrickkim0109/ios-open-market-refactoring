//
//  ModifyProductsUseCaseMock.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/02/01.
//

import Foundation

final class ModifyProductsUseCaseMock: ModifyProductsUseCase {
    var result: Void = ()
    var error: Error?
    
    func execute(
        productID: Int,
        product: TypedProductDetailsRequestDTO) async throws {
            if error == nil {
                return result
            } else {
                throw error ?? DataTransferError.noResponse
            }
        }
}
