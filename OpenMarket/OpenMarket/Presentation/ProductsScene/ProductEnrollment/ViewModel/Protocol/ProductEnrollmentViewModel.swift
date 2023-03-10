//
//  ProductEnrollmentViewModel.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/14.
//

protocol ProductEnrollmentViewModelInput {
    func didSelectEnrollmentButton(
        input: (TypedProductDetailsEntity,
                [ProductImageEntity])) async
    func didTapCancelButton()
}

protocol ProductEnrollmentViewModelOutput {
    var state: ProducEnrollmentState? { get }
}

enum ProducEnrollmentState {
    case failed(error: String)
}

protocol ProductEnrollmentViewModel: ProductEnrollmentViewModelInput, ProductEnrollmentViewModelOutput {}
