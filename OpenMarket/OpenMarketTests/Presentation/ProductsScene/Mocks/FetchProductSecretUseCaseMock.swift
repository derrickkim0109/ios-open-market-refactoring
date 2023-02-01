//
//  FetchProductSecretUseCaseMock.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/31.
//

import Foundation

final class FetchProductSecretUseCaseMock: FetchProductSecretUseCase {
    var error: Error?
    var productSecret = "123"
    
    func execute(
        productID: Int) async throws -> String {
            if error == nil {
                return productSecret
            } else {
                throw error ?? DataTransferError.noResponse
            }
        }
}
