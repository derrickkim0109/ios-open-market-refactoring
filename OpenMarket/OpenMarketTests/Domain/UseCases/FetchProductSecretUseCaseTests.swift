//
//  FetchProductSecretUseCaseTests.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/31.
//

import XCTest

final class FetchProductSecretUseCaseTests: XCTestCase {
    let productSecret = "123"

    enum ProductSecretRepositorySuccessTestError: Error {
        case failedFetching
    }

    func testFetchProductSecretUseCase_상품Secret연결이성공할_때() async {
        // given
        let expectation = self.expectation(description: "상품 Secret을 연결한다")

        let productSecretRepositoryMock = ProductSecretRepositoryMock(result: productSecret,
                                                                      error: nil)
        let useCase = DefaultFetchProductSecretUseCase(productSecretRepository: productSecretRepositoryMock)

        // when
        let productID = 1

        // then
        var responsedSecret = ""

        do {
            responsedSecret = try await useCase.execute(productID: productID)
            expectation.fulfill()
        } catch { }

        await waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(responsedSecret, productSecret)
    }

    func testFetchProductSecretUseCase_상품Secret연결이실패할_때() async {
        // given
        let expectation = self.expectation(description: "상품 Secret을 연결에 실패한다")

        let productSecretRepositoryMock = ProductSecretRepositoryMock(
            result: productSecret,
            error: ProductSecretRepositorySuccessTestError.failedFetching)
        let useCase = DefaultFetchProductSecretUseCase(productSecretRepository: productSecretRepositoryMock)

        // when
        let productID = 1

        // then
        var responsedSecret = ""

        do {
            responsedSecret = try await useCase.execute(productID: productID)
        } catch {
            expectation.fulfill()
        }

        await waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(responsedSecret.isEmpty)
    }
}
