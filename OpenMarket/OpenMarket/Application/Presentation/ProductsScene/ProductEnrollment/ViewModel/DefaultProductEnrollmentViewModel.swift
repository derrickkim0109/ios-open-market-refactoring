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
    
    init(
        enrollmentProductsUseCase: EnrollProductUseCase,
        actions: ProductEnrollmentViewModelActions? = nil) {
        self.enrollmentProductsUseCase = enrollmentProductsUseCase
        self.actions = actions
    }
    
    private func enroll(
        product: TypedProductDetailsRequestDTO,
        images: [ProductImageDTO]) async throws {
        do {
            try await enrollmentProductsUseCase.execute(
                product: product,
                images: images)
        } catch (let error) {
            throw error
        }
    }
    
    private func handlePostProduct(
        error: Error) -> String {
        return error.isInternetConnectionError ?
        NSLocalizedString(
            Const.noInternetConnection,
            comment: Const.empty) :
        NSLocalizedString(
            Const.failedPostingProduct,
            comment: Const.empty)
    }
    
    private enum Const {
        static let empty = ""
        static let noInternetConnection = "인터넷 연결에 실패하였습니다."
        static let failedPostingProduct = "상품을 등록할 수 없습니다."
        static let enrollmentSuccess = "상품 등록하였습니다"
    }
}

extension DefaultProductEnrollmentViewModel {
    func didSelectEnrollmentButton(
        input: (TypedProductDetailsRequestDTO,
                [ProductImageDTO])) async {
        do {
            let (product, images) = input
            
            try await enroll(
                product: product,
                images: images)

            await AlertControllerBulider.Builder()
                .setMessag(Const.enrollmentSuccess)
                .setConfirmAction({ [weak self](_) in
                    self?.actions?.dismissViewController()
                })
                .build()
                .present()
        } catch (let error) {
            state = .failed(
                error: handlePostProduct(error: error))
        }
    }
    
    func didTapCancelButton() {
        actions?.dismissViewController()
    }
}
