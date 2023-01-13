//
//  DefaultProductModificationViewModel.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/13.
//

import Foundation

final class DefaultProductModificationViewModel: ProductModificationViewModel {
    private let motifyProductsUseCase: ModifyProductsUseCase
    private let product: ProductDetailsEntity

    // MARK: Output
    var state: ProductModificationState?

    init(product: ProductDetailsEntity,
         motifyProductsUseCase: ModifyProductsUseCase) {
        self.product = product
        self.motifyProductsUseCase = motifyProductsUseCase
    }

    private func motify(productID: Int, product: TypedProductDetailsRequestDTO) async throws {
        do {
            try await motifyProductsUseCase.execute(productID: productID, product: product)
        } catch (let error) {
            throw error
        }
    }
}

extension DefaultProductModificationViewModel {
    func didSelectCompletionButton(input: TypedProductDetailsRequestDTO) async {
        do {
            try await motify(productID: product.id, product: input)
        } catch (let error) {
            state = .failed(error: error)
        }
    }

    func fetchData() -> ProductDetailsEntity {
        return product
    }
}
