//
//  FetchProductsUseCaseTests.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/30.
//

import XCTest

final class FetchProductsUseCaseTests: XCTestCase {
    let products: ProductsResponseDTO = {
        let pages = Product.sample
        return ProductsResponseDTO(pageNo: 1,
                                   itemsPerPage: 10,
                                   pages: pages)
    }()

    enum ProductsRepositorySuccessTestError: Error {
        case failedFetching
    }

    func testFetchProductsUseCase_상품연결이성공할_때() async {
        // given
        let expectation = self.expectation(description: "상품 연결한다")
        
        let productsRepositoryMock = ProductsRepositoryMock(result: products,
                                                            error: nil)
        let useCase = DefaultFetchProductsUseCase(productsRepository: productsRepositoryMock)

        // when
        let requestValue = FetchProductsUseCaseRequestValue(page: 1,
                                                            itemPerPage: 10)
        // then
        var responsedProducts: [Product] = []

        do {
            let data = try await useCase.execute(requestValue: requestValue)

            responsedProducts = data.pages

            expectation.fulfill()
        } catch { }

        await waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(responsedProducts[0].id, products.pages[0].id)
    }

    func testFetchProductsUseCase_상품연결이실패할_때() async {
        // given
        let expectation = self.expectation(description: "상품 연결이 실패한다")

        let productsRepositoryMock = ProductsRepositoryMock(result: products,
                                                            error: ProductsRepositorySuccessTestError.failedFetching)
        let useCase = DefaultFetchProductsUseCase(productsRepository: productsRepositoryMock)

        // when
        let requestValue = FetchProductsUseCaseRequestValue(page: 1,
                                                            itemPerPage: 10)

        // then
        var responsedProducts: [Product] = []

        do {
            let data = try await useCase.execute(requestValue: requestValue)
            responsedProducts = data.pages
        } catch {
            expectation.fulfill()
        }

        await waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(responsedProducts.isEmpty)
    }
}
