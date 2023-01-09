//
//  ProductsListViewModel.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

struct ProductsListViewModelActions {
    let showProductEnrollment: () -> Void
    let showProductDetails: (ProductEntity) -> Void
}

enum ProductsListViewModelLoading {
    case fullScreen
    case nextPage
}

protocol ProductsListViewModelInput {
    func transform(input: DefaultProductsListViewModel.Input) async -> DefaultProductsListViewModel.Output
    func viewDidLoad()
    func didLoadNextPage()
    func didSelectItem(_ item: ProductEntity)
    func didTapPlusButton()
}

protocol ProductsListViewModelOutput {
    var items: [ProductEntity] { get }
    var loading: ProductsListViewModelLoading? { get }
    var isEmpty: Bool { get }
}

protocol ProductsListViewModel: ProductsListViewModelInput, ProductsListViewModelOutput {}

final class DefaultProductsListViewModel: ProductsListViewModel {
    private let fetchProductsUseCase: FetchProductsUseCase
    private let actions: ProductsListViewModelActions?

    private var productList: [Product] = []
    
    private var currentPage: Int = 0
    private var totalPageCount: Int = 1
    private var hasMorePages: Bool { currentPage < totalPageCount }
    private var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }

    let items: [ProductEntity] = []
    let loading: ProductsListViewModelLoading? = .none
    var isEmpty: Bool { return items.isEmpty }

    enum State {
        case success(data: [ProductEntity])
        case failed(error: Error)
    }

    struct Input {
        var productListTrigger: (pageNumber: Int, itemsPerPage: Int)
    }

    class Output {
        var state: State?
    }

    init(fetchProductsUseCase: FetchProductsUseCase,
         actions: ProductsListViewModelActions? = nil) {
        self.fetchProductsUseCase = fetchProductsUseCase
        self.actions = actions
    }

    func transform(input: Input) async -> Output {
        let output = Output()

        do {
            let (pageNumber, itemsPerPage) = input.productListTrigger

            let data = try await load(pageNumber: pageNumber, itemsPerPage: itemsPerPage)
            output.state = .success(data: format(data: data?.pages))

        } catch (let error) {
            output.state = .failed(error: error)
        }

        return output
    }

    private func load(pageNumber: Int, itemsPerPage: Int) async throws -> ProductsRequestDTO? {
        do {
            let result = try await fetchProductsUseCase.execute(requestValue: FetchProductsUseCaseRequestValue(page: pageNumber, itemPerPage: itemsPerPage))
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
}

extension DefaultProductsListViewModel {
    func viewDidLoad() {

    }

    func didLoadNextPage() {

    }

    func didSelectItem(_ item: ProductEntity) {
        actions?.showProductDetails(item)
    }

    func didTapPlusButton() {
        actions?.showProductEnrollment()
    }
}
