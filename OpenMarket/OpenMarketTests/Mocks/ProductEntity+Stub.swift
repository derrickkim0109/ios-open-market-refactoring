//
//  ProductEntity+Stub.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/27.
//

import Foundation

extension ProductEntity {
    static func stub(
        id: Int = 1,
        vendorID: Int = 12,
        thumbnail: String = "image.png",
        name: String = "나뭇잎",
        currency: String = "KRW",
        originalPrice: Double = 123.0,
        discountedPrice: Double = 10.0,
        stock: Int = 10) -> Self {
        return ProductEntity(
            id: id,
            vendorID: vendorID,
            thumbnail: thumbnail,
            name: name,
            currency: currency,
            originalPrice: originalPrice,
            discountedPrice: discountedPrice,
            stock: stock)
    }
}

