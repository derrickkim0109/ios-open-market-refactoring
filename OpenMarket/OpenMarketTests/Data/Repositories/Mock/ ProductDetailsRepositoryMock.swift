//
//  ProductDetailsRepositoryMock.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/29.
//

import Foundation
import XCTest

struct ProductDetailsRepositoryMock: ProductDetailsRepository {
    var result: ProductDetailsRequestDTO
    var error: Error?

    func fetchProductDetails(
        productID: Int) async throws -> ProductDetailsEntity {
            if error == nil {
                return result.toDomain()
            } else {
                throw error ?? DataTransferError.noResponse
            }
        }
}
