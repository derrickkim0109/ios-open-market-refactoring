//
//  FetchProductDetailsUseCaseMock.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/31.
//

import Foundation

final class FetchProductDetailsUseCaseMock: FetchProductDetailsUseCase {
    var error: Error?
    var productInfo = ProductDetailsEntity.stub(images: ["apple.png"])
    
    func execute(
        productID: Int) async throws -> ProductDetailsEntity {
            if error == nil {
                return productInfo
            } else {
                throw error ?? DataTransferError.noResponse
            }
        }
}
