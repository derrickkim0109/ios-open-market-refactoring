//
//  DefaultProductsListViewModel.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import Foundation

final class DefaultProductsListViewModel: ProductsListViewModel {
    private let fetchProductsUseCase: FetchProductsUseCase
    private let actions: ProductsListViewModelActions?

    private var productList: [Product] = []

    // MARK: Output
    let loading: ProductsListViewModelLoading? = .none
    var state: ProductsListState?

    init(
        fetchProductsUseCase: FetchProductsUseCase,
        actions: ProductsListViewModelActions? = nil) {
            self.fetchProductsUseCase = fetchProductsUseCase
            self.actions = actions
        }

    private func fetch(
        pageNumber: Int,
        itemsPerPage: Int) async throws -> ProductsResponseDTO? {
        do {
            let result = try await fetchProductsUseCase.execute(
                requestValue: FetchProductsUseCaseRequestValue(page: pageNumber,
                                                               itemPerPage: itemsPerPage))
            return result
        } catch (let error) {
            throw error
        }

    private func handleFetchingProducts(
        error: Error) -> String {
            return error.isInternetConnectionError ?
            NSLocalizedString(
                Const.noInternetConnection,
                comment: Const.empty) :
            NSLocalizedString(
                Const.failedFetchingProducts,
                comment: Const.empty)
        }

    private enum Const {
        static let empty = ""
        static let noInternetConnection = "인터넷 연결에 실패하였습니다."
        static let failedFetchingProducts = "상품 리스트를 불러오는데 실패하였습니다."
    }
}

extension DefaultProductsListViewModel {
    func viewDidLoad() { }

    func transform(
        input: (pageNumber: Int,
                itemsPerPage: Int)) async {
        do {
            let (pageNumber, itemsPerPage) = input

            guard let data = try await fetch(
                pageNumber: pageNumber,
                itemsPerPage: itemsPerPage) else {
                return
            }

            state = .success(
                data: data)
        } catch (let error) {
            state = .failed(
                error: handleFetchingProducts(error: error))
        }
    }

    func didSelectItem(
        _ item: ProductEntity) {
            actions?.presentProductDetails(item)
        }

    func didTapEnrollmentButton() {
        actions?.presentProductEnrollment()
    }
}
