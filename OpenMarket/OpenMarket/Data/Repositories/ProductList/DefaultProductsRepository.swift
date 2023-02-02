//
//  DefaultProductsRepository.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/09.
//

import Foundation

final class DefaultProductsRepository {
    private let dataTransferService: DataTransferService

    init(
        dataTransferService: DataTransferService) {
            self.dataTransferService = dataTransferService
        }
}

extension DefaultProductsRepository: ProductsRepository {
    func fetchProductsList(
        page: Int,
        itemsPerPage: Int) async throws -> ProductsResponseDTO {
            let endpoint = APIEndpoints.getProducts(
                page,
                itemsPerPage)

            let data = try await dataTransferService.request(
                with: endpoint)

            let result = data.pages.map{ $0.toDomain() }

            return result
        }
}
