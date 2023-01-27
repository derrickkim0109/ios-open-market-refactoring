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

    init(fetchProductsUseCase: FetchProductsUseCase,
         actions: ProductsListViewModelActions? = nil) {
        self.fetchProductsUseCase = fetchProductsUseCase
        self.actions = actions
    }

    private func fetch(pageNumber: Int,
                       itemsPerPage: Int) async throws -> ProductsResponseDTO? {
        do {
            let result = try await fetchProductsUseCase.execute(requestValue:
                                                                    FetchProductsUseCaseRequestValue(page: pageNumber,
                                                                                                     itemPerPage: itemsPerPage))
            return result
        } catch (let error) {
            throw error
        }
    }

    private func format(data: [Product]?) -> [ProductEntity] {
        let convertedEntity = data?.compactMap{ $0.toDomain() }

        guard let convertedEntity else {
            return [ProductEntity]()
        }

        return convertedEntity
    }

    private func handleFetchingProducts(error: Error) -> String {
        return error.isInternetConnectionError ?
        NSLocalizedString(Const.noInternetConnection,
                          comment: Const.empty) :
        NSLocalizedString(Const.failedFetchingProducts,
                          comment: Const.empty)
    }

    private enum Const {
        static let empty = ""
        static let noInternetConnection = "No internet connection"
        static let failedFetchingProducts = "Failed fetching products"
    }
}

extension DefaultProductsListViewModel {
    func viewDidLoad() { }

    func transform(input: (pageNumber: Int,
                           itemsPerPage: Int)) async {
        do {
            let (pageNumber, itemsPerPage) = input
            let data = try await fetch(pageNumber: pageNumber,
                                       itemsPerPage: itemsPerPage)

            state = .success(data: format(data: data?.pages))

        } catch (let error) {
            state = .failed(error: handleFetchingProducts(error: error))
        }
    }
    
    func didSelectItem(_ item: ProductEntity) {
        actions?.presentProductDetails(item)
    }

    func didTapEnrollmentButton() {
        actions?.presentProductEnrollment()
    }
}
