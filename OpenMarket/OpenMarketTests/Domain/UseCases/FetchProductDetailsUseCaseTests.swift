//
//  FetchProductDetailsUseCaseTests.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/31.
//

import XCTest

final class FetchProductDetailsUseCaseTests: XCTestCase {
    let product: ProductDetailsRequestDTO = ProductDetailsRequestDTO.productInfo

    enum ProductDetailsRepositoryMockSuccessTestError: Error {
        case failedFetching
    }

    func testFetchProductDetailsUseCase_상품연결이성공할_때() async {
        // given
        let expectation = self.expectation(description: "상품 연결한다")

        let productDetailsRepositoryMock = ProductDetailsRepositoryMock(result: product,
                                                                        error: nil)
        let useCase = DefaultFetchProductDetailsUseCase(productDetailsRepository: productDetailsRepositoryMock)

        // when
        let productID = 1

        // then
        var responsedProduct: ProductDetailsRequestDTO?

        do {
            responsedProduct = try await useCase.execute(productID: productID)

            expectation.fulfill()
        } catch { }

        await waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(responsedProduct?.id, product.id)
    }

    func testFetchProductDetailsUseCase_상품연결이실패할_때() async {
        // given
        let expectation = self.expectation(description: "상품 연결에 실패한다")

        let productDetailsRepositoryMock = ProductDetailsRepositoryMock(
            result: product,
            error: ProductDetailsRepositoryMockSuccessTestError.failedFetching)
        
        let useCase = DefaultFetchProductDetailsUseCase(productDetailsRepository: productDetailsRepositoryMock)

        // when
        let productID = 1

        // then
        var responsedProduct: ProductDetailsRequestDTO?

        do {
            responsedProduct = try await useCase.execute(productID: productID)
        } catch {
            expectation.fulfill()
        }

        await waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responsedProduct)
    }
}
