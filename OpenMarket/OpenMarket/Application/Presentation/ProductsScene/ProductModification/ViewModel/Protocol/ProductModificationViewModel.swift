//
//  ProductModificationViewModel.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/13.
//

import Foundation

protocol ProductModificationViewModelInput {
    func didSelectCompletionButton(input: TypedProductDetailsRequestDTO) async
    func fetchData() -> ProductDetailsEntity
}

protocol ProductModificationViewModelOutput {
    var state: ProductModificationState? { get }
}

enum ProductModificationState {
    case failed(error: Error)
}

protocol ProductModificationViewModel: ProductModificationViewModelInput, ProductModificationViewModelOutput {}
