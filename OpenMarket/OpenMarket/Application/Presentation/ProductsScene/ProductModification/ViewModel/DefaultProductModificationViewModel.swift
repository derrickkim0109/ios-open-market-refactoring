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
    private let actions: ProductModificationViewModelActions?

    // MARK: Output
    var state: ProductModificationState?

    init(product: ProductDetailsEntity,
         motifyProductsUseCase: ModifyProductsUseCase,
         actions: ProductModificationViewModelActions? = nil) {
        self.product = product
        self.motifyProductsUseCase = motifyProductsUseCase
        self.actions = actions
    }

    private func motify(productID: Int,
                        product: TypedProductDetailsRequestDTO) async throws {
        do {
            try await motifyProductsUseCase.execute(productID: productID,
                                                    product: product)
        } catch (let error) {
            throw error
        }
    }

    private func handleModifyProduct(error: Error) -> String {
        return error.isInternetConnectionError ?
        NSLocalizedString(Const.noInternetConnection,
                          comment: Const.empty) :
        NSLocalizedString(Const.failedModifyingProduct,
                          comment: Const.empty)
    }

    private enum Const {
        static let empty = ""
        static let noInternetConnection = "No internet connection"
        static let failedModifyingProduct = "Failed modifying product"
    }
}

extension DefaultProductModificationViewModel {
    func didSelectCompletionButton(input: TypedProductDetailsRequestDTO) async {
        do {
            try await motify(productID: product.id, product: input)
            actions?.dismissViewController()
        } catch (let error) {
            state = .failed(error: handleModifyProduct(error: error))
        }
    }

    func didTapCancelButton() {
        actions?.dismissViewController()
    }

    func fetchData() -> ProductDetailsEntity {
        return product
    }
}
