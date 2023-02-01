//
//  ProductModificationViewModelTests.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/02/01.
//

import XCTest

final class ProductModificationViewModelTests: XCTestCase {
    private let bag = AnyCancelTaskBag()

    private enum ModifyProductsUseCaseError: Error {
        case someError
    }
    
    func test_ModifyProductsUseCase때_ViewModel은_데이터를_수정한다() async {
        // given
        let modifyProductsUseCaseMock = ModifyProductsUseCaseMock()

        let expectation = self.expectation(
            description: "ProductModificationViewModel은 상품을 수정한다.")

        // when
        let viewModel = DefaultProductModificationViewModel(
            product: ProductDetailsEntity.sample,
            motifyProductsUseCase: modifyProductsUseCaseMock)

        // then
        Task {
            await viewModel.didSelectModificationButton(
                input: TypedProductDetailsRequestDTO.sample)

            expectation.fulfill()
        }.store(in: bag)

        await waitForExpectations(timeout: 5,
                                  handler: nil)
    }

    func test_ModifyProductsUseCase가_Error를_반환할_때_ViewModelErrorString을_가지고있다() async {
        // given
        let modifyProductsUseCaseMock = ModifyProductsUseCaseMock()

        let expectation = self.expectation(
            description: "ProductModificationViewModel은 에러를 가진다.")

        // when
        modifyProductsUseCaseMock.error = ModifyProductsUseCaseError.someError

        let viewModel = DefaultProductModificationViewModel(
            product: ProductDetailsEntity.sample,
            motifyProductsUseCase: modifyProductsUseCaseMock)

        // then
        Task {
            await viewModel.didSelectModificationButton(
                input: TypedProductDetailsRequestDTO.sample)

            guard let state = viewModel.state else {
                return
            }

            switch state {
            case .failed(_):
                expectation.fulfill()
            }
        }.store(in: bag)

        await waitForExpectations(timeout: 5,
                                  handler: nil)
    }
}
