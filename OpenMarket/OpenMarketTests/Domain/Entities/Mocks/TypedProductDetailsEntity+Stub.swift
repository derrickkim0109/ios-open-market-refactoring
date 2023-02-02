//
//  TypedProductDetailsEntity+Stub.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/31.
//

import Foundation

extension TypedProductDetailsEntity {
    static func stub(
        name: String = "나뭇잎",
        description: String = "은행나무",
        price: Double = 100.0,
        currency: String = "krw",
        discountedPrice: Double? = 10.0,
        stock: Int? = 10,
        secret: String = "123"
    ) -> Self {
        return TypedProductDetailsEntity(
            name: name,
            description: description,
            price: price,
            currency: currency,
            discountedPrice: discountedPrice,
            stock: stock,
            secret: secret)
    }

    static let sample = TypedProductDetailsEntity.stub()
}
