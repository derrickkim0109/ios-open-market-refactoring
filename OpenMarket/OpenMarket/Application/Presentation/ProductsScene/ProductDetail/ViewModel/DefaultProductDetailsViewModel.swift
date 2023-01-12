//
//  DefaultProductDetailsViewModel.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

final class DefaultProductDetailsViewModel: ProductDetailsViewModel {
    private let fetchProductDetailsUseCase: FetchProductDetailsUseCase
    private let fetchProductSecretUseCase: FetchProductSecretUseCase
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

    init(product: ProductEntity,
         fetchProductDetailsUseCase: FetchProductDetailsUseCase,
         fetchProductSecretUseCase: FetchProductSecretUseCase,
         actions: ProductDetailsViewModelActions? = nil) {
        self.product = product
        self.fetchProductDetailsUseCase = fetchProductDetailsUseCase
        self.fetchProductSecretUseCase = fetchProductSecretUseCase
        self.actions = actions
    }

    func transform() async {
        do {
            let data = try await load(productID: product.id)
            let formattedData = format(productDetails: data)
            items = formattedData
            state = .success(data: formattedData)

            if isEqualVendorID {
                let data = try await fetchProductSecret(by: product.id)
                itemSecret = data
            }
        } catch (let error) {
            state = .failed(error: error)
        }
    }
    
    private func load(productID: Int) async throws -> ProductDetailsResponseDTO {
        do {
            let result = try await fetchProductDetailsUseCase.execute(productID: productID)
            return result
        } catch (let error) {
            throw error
        }
    }

    private func fetchProductSecret(by productID: Int) async throws -> String {
        do {
            let result = try await fetchProductSecretUseCase.execute(productID: productID)
            return result
        } catch (let error) {
            throw error
        }
    }
    private func format(productDetails: ProductDetailsResponseDTO) -> ProductDetailsEntity {
        let productInfo = productDetails.toDomain()
        return productInfo
    }
}

extension DefaultProductDetailsViewModel {
    func didSelectEditButton() {
        guard let model = items else { return }
        actions?.presentProductModitifation(model)
    }

    func didDeleteProducts(_ productID: Int) {

    }
}
