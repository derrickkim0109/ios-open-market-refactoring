//
//  ProductsListViewModelTests.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/31.
//

import XCTest

final class ProductsListViewModelTests: XCTestCase {
    private let bag = AnyCancelTaskBag()

    private enum FetchProductsUseCaseError: Error {
        case someError
    }

    func test_FetchProductsUseCase때_ViewModel은_데이터를_가지고있다() async {
        // given
        let fetchProductsUseCaseMock = FetchProductsUseCaseMock()
        let fetchProductsUseCaseRequestValue = (1, 10)
        let expectation = self.expectation(
            description: "ProductListViewModel은 상품리스트 데이터를 가지고 있다.")

        // when
        fetchProductsUseCaseMock.products = ProductEntity.sample

        let viewModel = DefaultProductsListViewModel(
            fetchProductsUseCase: fetchProductsUseCaseMock)

        // then
        Task {
            await viewModel.transform(
                input: fetchProductsUseCaseRequestValue)

            guard let state = viewModel.state else {
                return
            }

            switch state {
            case .success(let data):
                let ids = data.map { $0.id }
                XCTAssertEqual(ids[0], 1)
                expectation.fulfill()
            case .failed(_):
                break
            }
        }.store(
            in: bag)

        await waitForExpectations(timeout: 5,
                                  handler: nil)
    }

    func test_FetchProductsUseCase가_Error를_반환할_때_ViewModelErrorString을_가지고있다() async {
        // given
        let fetchProductsUseCaseMock = FetchProductsUseCaseMock()
        let fetchProductsUseCaseRequestValue = (1, 10)
        fetchProductsUseCaseMock.error = FetchProductsUseCaseError.someError

        let expectation = self.expectation(
            description: "ProductListViewModel은 에러를 가지고 있다.")

        // when
        let viewModel = DefaultProductsListViewModel(
            fetchProductsUseCase: fetchProductsUseCaseMock)

        // then
        Task {
            await viewModel.transform(
                input: fetchProductsUseCaseRequestValue)

            guard let state = viewModel.state else {
                return
            }

            switch state {
            case .success(_):
                break
            case .failed(let error):
                XCTAssertFalse(error.isEmpty)
                expectation.fulfill()
            }
        }.store(
            in: bag)

        await waitForExpectations(timeout: 5,
                                  handler: nil)
    }
}
