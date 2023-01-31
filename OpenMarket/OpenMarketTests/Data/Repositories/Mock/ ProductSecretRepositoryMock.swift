//
//  ProductSecretRepositoryMock.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/29.
//

import Foundation
import XCTest

struct ProductSecretRepositoryMock: ProductSecretRepository {
    var result: String
    var error: Error?
    
    func fetchProductSecret(
        productID: Int) async throws -> Endpoint<String>.Response {
            if error == nil {
                return result
            } else {
                throw error ?? DataTransferError.noResponse
            }
    }
}
