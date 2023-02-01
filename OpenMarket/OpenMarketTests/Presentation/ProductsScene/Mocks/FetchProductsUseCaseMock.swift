//
//  FetchProductsUseCaseMock.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/31.
//

import Foundation

final class FetchProductsUseCaseMock: FetchProductsUseCase {
    var error: Error?
    var page = ProductsResponseDTO(
        pageNo: 0,
        itemsPerPage: 0,
        pages: [])

    func execute(
        requestValue: FetchProductsUseCaseRequestValue) async throws -> ProductsResponseDTO {
            if error == nil {
                return page
            } else {
                throw error ?? DataTransferError.noResponse
            }
        }
}
