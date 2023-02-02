//
//  ProductEnrollmentViewModelTests.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/02/01.
//

import XCTest

final class ProductEnrollmentViewModelTests: XCTestCase {
    private let bag = AnyCancelTaskBag()
    
    private enum EnrollProductUseCaseError: Error {
        case someError
    }
    
    func test_EnrollProductUseCase때_ViewModel은_데이터를_등록한다() async {
        // given
        let enrollProductUseCaseMock = EnrollProductUseCaseMock()
        
        let expectation = self.expectation(
            description: "ProductEnrollmentViewModel은 상품을 등록한다.")
        
        // when
        let viewModel = DefaultProductEnrollmentViewModel(
            enrollmentProductsUseCase: enrollProductUseCaseMock)
        
        let productInfo = TypedProductDetailsEntity.sample
        let images = ProductImageEntity.sample
        
        // then
        Task {
            await viewModel.didSelectEnrollmentButton(
                input: (productInfo, images))
            
            expectation.fulfill()
        }.store(
            in: bag)
        
        await waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_EnrollProductUseCase가_Error를_반환할_때_ViewModelErrorString을_가지고있다() async {
        // given
        let enrollProductUseCaseMock = EnrollProductUseCaseMock()
        
        let expectation = self.expectation(description: "ProductEnrollmentViewModel은 에러를 가지고 있다.")
        
        // when
        enrollProductUseCaseMock.error = EnrollProductUseCaseError.someError
        
        let viewModel = DefaultProductEnrollmentViewModel(
            enrollmentProductsUseCase: enrollProductUseCaseMock)
        
        let productInfo = TypedProductDetailsEntity.sample
        let images = ProductImageEntity.sample
        
        // then
        Task {
            await viewModel.didSelectEnrollmentButton(
                input: (productInfo, images))
            
            guard let state = viewModel.state else {
                return
            }
            
            switch state {
            case .failed(_):
                expectation.fulfill()
            }
        }.store(
            in: bag)
        
        await waitForExpectations(timeout: 5,
                                  handler: nil)
    }
}
