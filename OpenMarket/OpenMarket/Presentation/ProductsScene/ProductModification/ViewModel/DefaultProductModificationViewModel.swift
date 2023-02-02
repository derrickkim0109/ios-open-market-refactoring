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

    init(
        product: ProductDetailsEntity,
        motifyProductsUseCase: ModifyProductsUseCase,
        actions: ProductModificationViewModelActions? = nil) {
        self.product = product
        self.motifyProductsUseCase = motifyProductsUseCase
        self.actions = actions
    }

    private func motify(
        productID: Int,
        product: TypedProductDetailsEntity) async throws {
        do {
            try await motifyProductsUseCase.execute(
                productID: productID,
                product: product)
        } catch (let error) {
            throw error
        }
    }

    private func handleModifyProduct(
        error: Error) -> String {
        return error.isInternetConnectionError ?
        NSLocalizedString(
            Const.noInternetConnection,
            comment: Const.empty) :
        NSLocalizedString(
            Const.failedModifyingProduct,
            comment: Const.empty)
    }

    private enum Const {
        static let empty = ""
        static let noInternetConnection = "인터넷 연결에 실패하였습니다."
        static let failedModifyingProduct = "상품 수정에 실패하였습니다."
    }
}

extension DefaultProductModificationViewModel {
    func didSelectModificationButton(
        input: TypedProductDetailsEntity) async {
        do {
            try await motify(
                productID: product.id,
                product: input)

            actions?.dismissViewController()
        } catch (let error) {
            state = .failed(
                error: handleModifyProduct(error: error))
        }
    }

    func didTapCancelButton() {
        dismissScene()
    }

    func fetchData() -> ProductDetailsEntity {
        return product
    }

    func dismissScene() {
        actions?.dismissViewController()
    }
}
