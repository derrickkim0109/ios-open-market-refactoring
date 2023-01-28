//
//  DefaultProductDetailsViewModel.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import Foundation

final class DefaultProductDetailsViewModel: ProductDetailsViewModel {
    private let fetchProductDetailsUseCase: FetchProductDetailsUseCase
    private let fetchProductSecretUseCase: FetchProductSecretUseCase
    private let deleteProductUseCase: DeleteProductUseCase
    private let actions: ProductDetailsViewModelActions?

    // MARK: Output
    var loading: ProductsListViewModelLoading?
    var state: ProductDetailsState?
    var items: ProductDetailsEntity?
    var itemSecret: String = ""
    var isEmptyStock: Bool {
        return items?.stock == 0
    }
    var isEqualVendorID: Bool {
        return product.vendorID == User.vendorID
    }

    private let product: ProductEntity

    init(
        product: ProductEntity,
        fetchProductDetailsUseCase: FetchProductDetailsUseCase,
        fetchProductSecretUseCase: FetchProductSecretUseCase,
        deleteProductUseCase: DeleteProductUseCase,
        actions: ProductDetailsViewModelActions? = nil) {
        self.product = product
        self.fetchProductDetailsUseCase = fetchProductDetailsUseCase
        self.fetchProductSecretUseCase = fetchProductSecretUseCase
        self.deleteProductUseCase = deleteProductUseCase
        self.actions = actions
    }

    private func fetchProduct(
        productID: Int) async throws -> ProductDetailsRequestDTO {
        do {
            let result = try await fetchProductDetailsUseCase.execute(
                productID: productID)

            return result
        } catch (let error) {
            throw error
        }
    }

    private func fetchProductSecret(
        by productID: Int) async throws -> String {
        do {
            let result = try await fetchProductSecretUseCase.execute(
                productID: productID)

            return result
        } catch (let error) {
            throw error
        }
    }

    private func deleteProduct(
        deleteURL: String) async throws {
        do {
            try await deleteProductUseCase.execute(
                deleteURL: deleteURL)
        } catch (let error) {
            throw error
        }
    }

    private func checkVendorID() async {
        do {
            if isEqualVendorID {
                let data = try await fetchProductSecret(
                    by: product.id)

                itemSecret = data
            }
        } catch (let error) {
            state = .failed(
                error: handleFetchProductSecret(error: error))
        }
    }

    private func handleFetchProductNetwork(
        error: Error) -> String {
        return error.isInternetConnectionError ?
        NSLocalizedString(
            Const.noInternetConnection,
            comment: Const.empty) :
        NSLocalizedString(
            Const.failedFetchingProduct,
            comment: Const.empty)
    }

    private func handleFetchProductSecret(
        error: Error) -> String {
        return error.isInternetConnectionError ?
        NSLocalizedString(
            Const.noInternetConnection,
            comment: Const.empty) :
        NSLocalizedString(
            Const.failedFetchingProductSecret,
            comment: Const.empty)
    }

    private func handleDeletingProduct(
        error: Error) -> String {
        return error.isInternetConnectionError ?
        NSLocalizedString(
            Const.noInternetConnection,
            comment: Const.empty) :
        NSLocalizedString(
            Const.failedDeletingProduct,
            comment: Const.empty)
    }

    private func format(
        productDetails: ProductDetailsRequestDTO) -> ProductDetailsEntity {
        let productInfo = productDetails.toDomain()
        return productInfo
    }

    private enum Const {
        static let empty = ""
        static let noInternetConnection = "인터넷 연결에 실패하였습니다."
        static let failedFetchingProduct = "상품을 불러오는데 실패하였습니다."
        static let failedFetchingProductSecret = "상품의 Secret을 불러오는데 실패하였습니다."
        static let failedDeletingProduct = "상품을 제거할 수 없습니다."
    }
}

extension DefaultProductDetailsViewModel {
    func transform() async {
        do {
            let data = try await fetchProduct(
                productID: product.id)
            
            let formattedData = format(
                productDetails: data)

            items = formattedData

            state = .success(
                data: formattedData)

            await checkVendorID()
        } catch (let error) {
            state = .failed(
                error: handleFetchProductNetwork(error: error))
        }
    }
    
    func didSelectEditButton() {
        guard let model = items else {
            return
        }

        actions?.presentProductModitifation(model)
    }

    func didSelectDeleteButton() async {
        do {
            try await deleteProduct(
                deleteURL: itemSecret)
        } catch (let error) {
            state = .failed(
                error: handleDeletingProduct(error: error))
        }
    }

    func popViewController() {
        actions?.popViewController()
    }
}
