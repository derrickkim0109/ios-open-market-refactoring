//
//  DefaultDeleteProductRepository.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/12.
//

import Foundation

final class DefaultDeleteProductRepository {
    private let dataTransferService: DataTransferService

    init(
        dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultDeleteProductRepository: DeleteProductRepository {
    func deleteProduct(
        deleteURI: String) async throws {
        let endpoint = APIEndpoints.deleteProduct(
            deleteURL: deleteURI)

        try await dataTransferService.request(
            with: endpoint)
    }
}
