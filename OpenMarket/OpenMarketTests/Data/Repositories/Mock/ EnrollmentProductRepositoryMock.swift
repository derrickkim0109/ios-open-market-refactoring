//
//  EnrollmentProductRepositoryMock.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/29.
//

import Foundation
import XCTest

struct EnrollmentProductRepositoryMock: EnrollmentProductRepository {
    var result: Void
    var error: Error?
    
    func enrollProduct(
        product: TypedProductDetailsRequestDTO,
        images: [ProductImageDTO]) async throws {
            if error == nil {
                return result
            } else {
                throw error ?? DataTransferError.noResponse
            }
        }
}
