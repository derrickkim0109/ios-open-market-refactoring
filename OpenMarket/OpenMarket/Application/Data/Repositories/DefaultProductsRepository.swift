//
//  DefaultProductsRepository.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/09.
//

import Foundation

final class DefaultProductsRepository {
    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultProductsRepository: ProductsRepository {
    public func fetchProductsList(page: Int, itemsPerPage: Int) async throws -> ProductsRequestDTO {
        let endpoint = APIEndpoints.getProducts(page, itemsPerPage)
        let result = try await self.dataTransferService.request(with: endpoint) 
        return result
    }
}
