//
//  ProductsListViewModel.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/10.
//

import Foundation

protocol ProductsListViewModel: ProductsListViewModelInput, ProductsListViewModelOutput {}

protocol ProductsListViewModelInput {
    func transform(input: (pageNumber: Int, itemsPerPage: Int)) async
    func viewDidLoad()
    func didSelectItem(_ item: ProductEntity)
    func didTapPlusButton()
}

protocol ProductsListViewModelOutput {
    var loading: ProductsListViewModelLoading? { get }
    var state: ProductsListState? { get }
}

enum ProductsListState {
    case success(data: [ProductEntity])
    case failed(error: Error)
}

enum ProductsListViewModelLoading {
    case fullScreen
    case nextPage
}
