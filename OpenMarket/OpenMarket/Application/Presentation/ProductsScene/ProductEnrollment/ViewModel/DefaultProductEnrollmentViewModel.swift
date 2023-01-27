//
//  DefaultProductEnrollmentViewModel.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/14.
//

import Foundation

final class DefaultProductEnrollmentViewModel: ProductEnrollmentViewModel {
    private let enrollmentProductsUseCase: EnrollProductUseCase
    private let actions: ProductEnrollmentViewModelActions?
    
    // MARK: Output
    var state: ProducEnrollmentState?
    
    init(enrollmentProductsUseCase: EnrollProductUseCase,
         actions: ProductEnrollmentViewModelActions? = nil) {
        self.enrollmentProductsUseCase = enrollmentProductsUseCase
        self.actions = actions
    }
    
    private func enroll(product: TypedProductDetailsRequestDTO,
                        images: [ProductImageDTO]) async throws {
        do {
            try await enrollmentProductsUseCase.execute(product: product,
                                                        images: images)
        } catch (let error) {
            throw error
        }
    }
    
    private func handlePostProduct(error: Error) -> String {
        return error.isInternetConnectionError ?
        NSLocalizedString(Const.noInternetConnection,
                          comment: Const.empty) :
        NSLocalizedString(Const.failedPostingProduct,
                          comment: Const.empty)
    }
    
    private enum Const {
        static let empty = ""
        static let noInternetConnection = "No internet connection"
        static let failedPostingProduct = "Failed posting product"
    }
}

extension DefaultProductEnrollmentViewModel {
    func didSelectCompletionButton(input: (TypedProductDetailsRequestDTO,
                                           [ProductImageDTO])) async {
        do {
            let (product, images) = input
            try await enroll(product: product,
                             images: images)
            
            actions?.dismissViewController()
        } catch (let error) {
            state = .failed(error: handlePostProduct(error: error))
        }
    }
    
    func didTapCancelButton() {
        actions?.dismissViewController()
    }
}
