//
//  EnrollProductUseCaseTests.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/31.
//

import XCTest

final class EnrollProductUseCaseTests: XCTestCase {
    enum EnrollmentProductRepositorySuccessTestError: Error {
        case failedEnrollingProduct
    }
    
    func testEnrollProductUseCase_상품등록에성공할_때() async {
        // given
        let expectation = self.expectation(description: "상품을 등록한다.")
        
        let enrollmentProductRepositoryMock = EnrollmentProductRepositoryMock(result: (),
                                                                              error: nil)
        let useCase = DefaultEnrollProductUseCase(enrollmentProductRepository: enrollmentProductRepositoryMock)
        
        // when
        let typedProduct = TypedProductDetailsEntity.stub()
        let images = ProductImageEntity.sample

        // then
        do {
            try await useCase.execute(product: typedProduct,
                                      images: images)
            expectation.fulfill()
        } catch { }
        
        await waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testEnrollProductUseCase_상품등록에실패할_때() async {
        // given
        let expectation = self.expectation(description: "상품을 등록에 실패한다.")
        
        let enrollmentProductRepositoryMock = EnrollmentProductRepositoryMock(
            result: (),
            error: EnrollmentProductRepositorySuccessTestError.failedEnrollingProduct)
        
        let useCase = DefaultEnrollProductUseCase(enrollmentProductRepository: enrollmentProductRepositoryMock)
        
        // when
        let typedProduct = TypedProductDetailsEntity.stub()
        let images = ProductImageEntity.sample

        // then
        do {
            try await useCase.execute(product: typedProduct,
                                      images: images)
        } catch {
            expectation.fulfill()
        }
        
        await waitForExpectations(timeout: 5, handler: nil)
    }
}
