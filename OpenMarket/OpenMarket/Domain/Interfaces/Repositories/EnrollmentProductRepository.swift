//
//  EnrollmentProductRepository.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/14.
//

import Foundation

protocol EnrollmentProductRepository {
    func enrollProduct(
        product: TypedProductDetailsEntity,
        images: [ProductImageEntity]) async throws -> Endpoint<()>.Response
}
