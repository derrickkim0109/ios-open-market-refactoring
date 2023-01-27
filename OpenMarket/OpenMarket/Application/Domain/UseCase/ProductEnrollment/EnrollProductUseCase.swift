//
//  EnrollProductUseCase.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/14.
//

protocol EnrollProductUseCase {
    func execute(product: TypedProductDetailsRequestDTO, images: [ProductImageDTO]) async throws
}

final class DefaultEnrollProductUseCase: EnrollProductUseCase {
    private let enrollmentProductRepository: EnrollmentProductRepository

    init(enrollmentProductRepository: EnrollmentProductRepository) {
        self.enrollmentProductRepository = enrollmentProductRepository
    }

    func execute(product: TypedProductDetailsRequestDTO,
                 images: [ProductImageDTO]) async throws  {
        return try await enrollmentProductRepository.enrollProduct(product: product,
                                                                   images: images)
    }
}
