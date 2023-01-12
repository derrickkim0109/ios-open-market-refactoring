//
//  ProductDetailsViewModel.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/10.
//

protocol ProductDetailsViewModelInput {
    func transform() async
    func didSelectEditButton()
    func didSelectDeleteButton() async throws
}

protocol ProductDetailsViewModelOutput {
    var loading: ProductsListViewModelLoading? { get }
    var state: ProductDetailsState? { get }
    var items: ProductDetailsEntity? { get }
    var itemSecret: String { get }
    var isEmptyStock: Bool { get }
    var isEqualVendorID: Bool { get }
}

enum ProductDetailsState {
    case success(data: ProductDetailsEntity)
    case failed(error: Error)
}

protocol ProductDetailsViewModel: ProductDetailsViewModelInput, ProductDetailsViewModelOutput {}
