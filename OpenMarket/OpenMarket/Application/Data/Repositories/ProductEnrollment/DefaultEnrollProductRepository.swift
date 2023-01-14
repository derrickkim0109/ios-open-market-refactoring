//
//  DefaultEnrollProductRepository.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/14.
//

import Foundation

final class DefaultEnrollProductRepository {
    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultEnrollProductRepository: EnrollmentProductRepository {
    func enrollProduct(product: TypedProductDetailsRequestDTO, images: [ProductImageDTO]) async throws {
        let productData = try product.toEncode()
        let endpoint = APIEndpoints.postProductEnrollment(product: productData, images: images)
        return try await self.dataTransferService.request(with: endpoint)
    }
}
