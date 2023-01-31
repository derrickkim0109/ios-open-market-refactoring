//
//  ModifyProductRepositoryMock.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/29.
//

import Foundation
import XCTest

struct ModifyProductRepositoryMock: ModifyProductRepository {
    var result: Void
    var error: Error?
    
    func modifyProduct(
        productID: Int,
        product: TypedProductDetailsRequestDTO) async throws {
            if error == nil {
                return result
            } else {
                throw error ?? DataTransferError.noResponse
            }
        }
}
