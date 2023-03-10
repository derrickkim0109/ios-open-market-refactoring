//
//  DefaultEnrollProductRepository.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/14.
//

import Foundation

final class DefaultEnrollProductRepository {
    private let dataTransferService: DataTransferService
    
    init(
        dataTransferService: DataTransferService) {
            self.dataTransferService = dataTransferService
        }
}

extension DefaultEnrollProductRepository: EnrollmentProductRepository {
    func enrollProduct(
        product: TypedProductDetailsEntity,
        images: [ProductImageEntity]) async throws {
            let productDTO = product.generate()
            let imagesDTO = images.map{ $0.generate() }

            guard let endpoint = APIEndpoints.postProductEnrollment(
                product: productDTO,
                images: imagesDTO) else {
                return
            }
            
            return try await dataTransferService.request(
                with: endpoint)
        }
}
