//
//  DefaultProductSecretRepository.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/12.
//

import Foundation

final class DefaultProductSecretRepository {
    private let dataTransferService: DataTransferService

    init(
        dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultProductSecretRepository: ProductSecretRepository {
    func fetchProductSecret(
        productID: Int) async throws -> Endpoint<String>.Response {
        let endpoint = APIEndpoints.postProductSecret(productID)
            
        let result = try await dataTransferService.request(
            with: endpoint)
        return result
    }
}
