//
//  TypedProductDetailsRequestDTO+Stub.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/31.
//

import Foundation

extension TypedProductDetailsRequestDTO {
    static func stub(
        name: String,
        description: String,
        price: Double,
        currency: String,
        discountedPrice: Double?,
        stock: Int?,
        secret: String
    ) -> Self {
        return TypedProductDetailsRequestDTO(
            name: name,
            description: description,
            price: price,
            currency: currency,
            discountedPrice: discountedPrice,
            stock: stock,
            secret: secret)
    }
}
