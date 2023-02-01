//
//  ModifyProductsUseCaseTests.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/31.
//

import XCTest

final class ModifyProductsUseCaseTests: XCTestCase {
    enum ModifyProductRepositoryMockSuccessTestError: Error {
        case failedModifyingProduct
    }

    func testModifyProductsUseCase_상품수정에성공할_때() async {
        // given
        let expectation = self.expectation(description: "상품을 수정한다.")

        let modifyProductRepositoryMock = ModifyProductRepositoryMock(result: (),
                                                                      error: nil)
        let useCase = DefaultModifyProductsUseCase(modifyProductRepository: modifyProductRepositoryMock)

        // when
        let productID = 1

        let typedProduct = TypedProductDetailsRequestDTO.stub(
            name: "나뭇잎",
            description: "은행나무 산",
            price: 10000.0,
            currency: "krw",
            discountedPrice: 1.0,
            stock: 10,
            secret: "123")

        // then
        do {
            try await useCase.execute(productID: productID,
                                      product: typedProduct)
            expectation.fulfill()
        } catch { }

        await waitForExpectations(timeout: 5, handler: nil)
    }

    func testModifyProductsUseCase_상품수정에실패할_때() async {
        // given
        let expectation = self.expectation(description: "상품을 수정에 실패한다.")

        let modifyProductRepositoryMock = ModifyProductRepositoryMock(
            result: (),
            error: ModifyProductRepositoryMockSuccessTestError.failedModifyingProduct)
        let useCase = DefaultModifyProductsUseCase(modifyProductRepository: modifyProductRepositoryMock)

        // when
        let productID = 1

        let typedProduct = TypedProductDetailsRequestDTO.stub(
            name: "나뭇잎",
            description: "은행나무 산",
            price: 10000.0,
            currency: "krw",
            discountedPrice: 1.0,
            stock: 10,
            secret: "123")

        // then
        do {
            try await useCase.execute(productID: productID,
                                      product: typedProduct)
        } catch {
            expectation.fulfill()
        }

        await waitForExpectations(timeout: 5, handler: nil)
    }
}
