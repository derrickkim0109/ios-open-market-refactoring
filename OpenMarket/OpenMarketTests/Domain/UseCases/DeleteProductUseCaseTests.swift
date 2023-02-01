//
//  DeleteProductUseCaseTests.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/31.
//

import XCTest

final class DeleteProductUseCaseTests: XCTestCase {
    enum DeleteProductRepositorySuccessTestError: Error {
        case failedDeletingProduct
    }

    func testDeleteProductUseCase_상품삭제가성공할_때() async {
        // given
        let expectation = self.expectation(description: "상품을 삭제한다.")

        let deleteProductRepositoryMock = DeleteProductRepositoryMock(result: (),
                                                                      error: nil)
        let useCase = DefaultDeleteProductDetailsUseCase(deleteProductRepository: deleteProductRepositoryMock)

        // when
        let deleteURL = "http://www.test.com"

        // then
        do {
            try await useCase.execute(deleteURL: deleteURL)
            expectation.fulfill()
        } catch { }

        await waitForExpectations(timeout: 5, handler: nil)
    }

    func testDeleteProductUseCase_상품삭제가실패할_때() async {
        // given
        let expectation = self.expectation(description: "상품 삭제에 실패한다.")

        let deleteProductRepositoryMock = DeleteProductRepositoryMock(
            result: (),
            error: DeleteProductRepositorySuccessTestError.failedDeletingProduct)
        
        let useCase = DefaultDeleteProductDetailsUseCase(deleteProductRepository: deleteProductRepositoryMock)

        // when
        let deleteURL = "http://www.test.com"

        // then
        do {
            try await useCase.execute(deleteURL: deleteURL)

        } catch {
            expectation.fulfill()
        }

        await waitForExpectations(timeout: 5, handler: nil)
    }
}
