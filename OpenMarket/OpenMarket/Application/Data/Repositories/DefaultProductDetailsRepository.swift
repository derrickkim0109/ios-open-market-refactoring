//
//  DefaultProductDetailsRepository.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/10.
//

import Foundation

final class DefaultProductDetailsRepository {
    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultProductDetailsRepository: ProductDetailsRepository {
    func fetchProductDetails(productID: Int) async throws -> ProductDetailsResponseDTO {
        let endpoint = APIEndpoints.getProductDetails(productID)
        let result = try await self.dataTransferService.request(with: endpoint)
        return result
    }
}
