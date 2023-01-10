//
//  ProductDetailsViewModel.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/10.
//

protocol ProductDetailsViewModelInput {
    func transform(input: Int) async
    func didSelectEditButton()
    func didDeleteProducts(_ productID: Int)
}

protocol ProductDetailsViewModelOutput {
    var loading: ProductsListViewModelLoading? { get }
    var state: ProductDetailsState? { get }
}

enum ProductDetailsState {
    case success(data: ProductDetailsEntity)
    case failed(error: Error)
}

protocol ProductDetailsViewModel: ProductDetailsViewModelInput, ProductDetailsViewModelOutput {}
