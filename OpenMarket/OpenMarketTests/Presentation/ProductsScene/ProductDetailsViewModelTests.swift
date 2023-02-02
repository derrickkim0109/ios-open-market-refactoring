//
//  ProductDetailsViewModelTests.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/31.
//

import XCTest

final class ProductDetailsViewModelTests: XCTestCase {
    private let bag = AnyCancelTaskBag()
    
    private enum FetchProductDetailsUseCaseError: Error {
        case someError
    }
    
    func test_FetchProductDetailsUseCase때_ViewModel은_데이터를_가지고있다() async {
        // given
        let fetchProductDetailsUseCaseMock = FetchProductDetailsUseCaseMock()
        let fetchProductSecretUseCaseMock = FetchProductSecretUseCaseMock()
        let deleteProductUseCaseMock = DeleteProductUseCaseMock()
        
        let expectation = self.expectation(
            description: "ProductDetailsViewModel은 상품 정보 데이터를 가지고 있다.")
        
        let productInfo = ProductDetailsEntity.stub(images: ["apple.png"])
        
        // when
        fetchProductDetailsUseCaseMock.productInfo = productInfo
        
        let viewModel = DefaultProductDetailsViewModel(
            product: ProductEntity.stub(),
            fetchProductDetailsUseCase: fetchProductDetailsUseCaseMock,
            fetchProductSecretUseCase: fetchProductSecretUseCaseMock,
            deleteProductUseCase: deleteProductUseCaseMock)
        
        // then
        Task {
            await viewModel.transform()
            
            guard let state = viewModel.state else {
                return
            }
            
            switch state {
            case .success(let data):
                XCTAssertEqual(data.id, 1)
                expectation.fulfill()
            case .failed(_):
                break
            }
            
        }.store(
            in: bag)
        
        await waitForExpectations(timeout: 5,
                                  handler: nil)
    }
    
    func test_FetchProductDetailsUseCase가_Error를_반환할_때_ViewModelErrorString을_가지고있다() async {
        // given
        let fetchProductDetailsUseCaseMock = FetchProductDetailsUseCaseMock()
        let fetchProductSecretUseCaseMock = FetchProductSecretUseCaseMock()
        let deleteProductUseCaseMock = DeleteProductUseCaseMock()
        
        let expectation = self.expectation(
            description: "ProductDetailsViewModel은 Error를 가지고 있다.")
        
        // when
        fetchProductDetailsUseCaseMock.error = FetchProductDetailsUseCaseError.someError
        
        let viewModel = DefaultProductDetailsViewModel(
            product: ProductEntity.stub(),
            fetchProductDetailsUseCase: fetchProductDetailsUseCaseMock,
            fetchProductSecretUseCase: fetchProductSecretUseCaseMock,
            deleteProductUseCase: deleteProductUseCaseMock)
        
        // then
        Task {
            await viewModel.transform()
            
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
