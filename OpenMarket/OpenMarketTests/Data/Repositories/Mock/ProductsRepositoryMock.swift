//
//  ProductsRepositoryMock.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/29.
//

import Foundation
import XCTest

struct ProductsRepositoryMock: ProductsRepository {
    var result: [ProductEntity]
    var error: Error?

    func fetchProductsList(
        page: Int,
        itemsPerPage: Int) async throws -> [ProductEntity] {
            if error == nil {
                return result
            } else {
                throw error ?? DataTransferError.noResponse
            }
        }
}

