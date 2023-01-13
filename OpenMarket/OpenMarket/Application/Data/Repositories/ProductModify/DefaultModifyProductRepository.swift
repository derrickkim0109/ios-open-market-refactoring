//
//  DefaultModifyProductRepository.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/13.
//

import Foundation

final class DefaultModifyProductRepository {
    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultModifyProductRepository: ModifyProductRepository {
    func modifyProduct(productID: Int, product: TypedProductDetailsRequestDTO) async throws -> Endpoint<()>.Response {
        let endpoint = APIEndpoints.patchProduct(productID, product: product)
        return try await self.dataTransferService.request(with: endpoint)
    }
}
