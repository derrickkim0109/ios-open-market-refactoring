//
//  DefaultModifyProductRepository.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/13.
//

import Foundation

final class DefaultModifyProductRepository {
    private let dataTransferService: DataTransferService
    
    init(
        dataTransferService: DataTransferService) {
            self.dataTransferService = dataTransferService
        }
}

extension DefaultModifyProductRepository: ModifyProductRepository {
    func modifyProduct(
        productID: Int,
        product: TypedProductDetailsEntity) async throws -> Endpoint<()>.Response {
            let productDTO = product.generate()

            let endpoint = APIEndpoints.patchProduct(
                productID,
                product: productDTO)
            
            return try await dataTransferService.request(
                with: endpoint)
        }
}
