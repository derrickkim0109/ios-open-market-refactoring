//
//  ProductsRepositoryMock.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/29.
//

import Foundation
import XCTest

struct ProductsRepositoryMock: ProductsRepository {
    var result: ProductsResponseDTO
    var error: Error?

    func fetchProductsList(
        page: Int,
        itemsPerPage: Int) async throws -> Endpoint<ProductsResponseDTO>.Response {
            if error == nil {
                return result
            } else {
                throw error ?? DataTransferError.noResponse
            }
        }
}

