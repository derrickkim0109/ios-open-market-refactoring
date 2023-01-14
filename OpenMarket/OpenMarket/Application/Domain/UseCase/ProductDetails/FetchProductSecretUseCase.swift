//
//  FetchProductSecretUseCase.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/12.
//

protocol FetchProductSecretUseCase {
    func execute(productID: Int) async throws -> String
}

final class DefaultFetchProductSecretUseCase: FetchProductSecretUseCase {
    private let productSecretRepository: ProductSecretRepository

    init(productSecretRepository: ProductSecretRepository) {
        self.productSecretRepository = productSecretRepository
    }

    func execute(productID: Int) async throws -> String {
        return try await productSecretRepository.fetchProductSecret(productID: productID)
    }
}
