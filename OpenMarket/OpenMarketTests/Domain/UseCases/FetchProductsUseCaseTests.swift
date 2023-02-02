//
//  FetchProductsUseCaseTests.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/30.
//

import XCTest

final class FetchProductsUseCaseTests: XCTestCase {
    let products: [ProductEntity] = {
        let products = Product.list.map{ $0.toDomain() }
        return products
    }()

    enum ProductsRepositorySuccessTestError: Error {
        case failedFetching
    }

    func testFetchProductsUseCase_상품리스트연결이성공할_때() async {
        // given
        let expectation = self.expectation(description: "상품 리스트에 연결한다.")
        
        let productsRepositoryMock = ProductsRepositoryMock(result: products,
                                                            error: nil)
        let useCase = DefaultFetchProductsUseCase(productsRepository: productsRepositoryMock)

        // when
        let requestValue = FetchProductsUseCaseRequestValue(page: 1,
                                                            itemPerPage: 10)
        // then
        var responsedProducts: [ProductEntity] = []

        do {
            let data = try await useCase.execute(requestValue: requestValue)

            responsedProducts = data

            expectation.fulfill()
        } catch { }

        await waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(responsedProducts[0].id, products[0].id)
    }

    func testFetchProductsUseCase_상품리스트연결이실패할_때() async {
        // given
        let expectation = self.expectation(description: "상품 리스트 연결에 실패한다.")

        let productsRepositoryMock = ProductsRepositoryMock(result: products,
                                                            error: ProductsRepositorySuccessTestError.failedFetching)
        let useCase = DefaultFetchProductsUseCase(productsRepository: productsRepositoryMock)

        // when
        let requestValue = FetchProductsUseCaseRequestValue(page: 1,
                                                            itemPerPage: 10)

        // then
        var responsedProducts: [ProductEntity] = []

        do {
            let data = try await useCase.execute(requestValue: requestValue)
            responsedProducts = data
        } catch {
            expectation.fulfill()
        }

        await waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(responsedProducts.isEmpty)
    }
}
