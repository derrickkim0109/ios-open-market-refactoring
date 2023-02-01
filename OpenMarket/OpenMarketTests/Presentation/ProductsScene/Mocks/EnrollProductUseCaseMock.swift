//
//  EnrollProductUseCaseMock.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/02/01.
//

import Foundation

final class EnrollProductUseCaseMock: EnrollProductUseCase {
    var result: Void = ()
    var error: Error?
    
    func execute(
        product: TypedProductDetailsRequestDTO,
        images: [ProductImageDTO]) async throws {
            if error == nil {
                return result
            } else {
                throw error ?? DataTransferError.noResponse
            }
        }
}
