//
//  DeleteProductRepositoryMock.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/29.
//

import Foundation
import XCTest

struct DeleteProductRepositoryMock: DeleteProductRepository {
    var result: Void
    var error: Error?

    func deleteProduct(
        deleteURI: String) async throws {
            if error == nil {
                return result
            } else {
                throw error ?? DataTransferError.noResponse
            }
        }
}
