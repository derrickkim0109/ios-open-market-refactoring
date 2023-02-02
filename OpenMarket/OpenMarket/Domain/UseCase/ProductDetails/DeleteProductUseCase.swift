//
//  DeleteProductUseCase.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/12.
//

protocol DeleteProductUseCase {
    func execute(
        deleteURL: String) async throws
}

final class DefaultDeleteProductDetailsUseCase: DeleteProductUseCase {
    private let deleteProductRepository: DeleteProductRepository

    init(
        deleteProductRepository: DeleteProductRepository) {
        self.deleteProductRepository = deleteProductRepository
    }

    func execute(
        deleteURL: String) async throws {
        return try await deleteProductRepository.deleteProduct(
            deleteURI: deleteURL)
    }
}
