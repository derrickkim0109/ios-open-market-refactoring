//
//  ProductEntity+Stub.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/31.
//

import Foundation

extension ProductEntity {
    static func stub(
        id: Int = 1,
        vendorID: Int = 12,
        thumbnail: String = "image.png",
        name: String = "맥북",
        currency: String = "krw",
        originalPrice: Double = 1000000.0,
        discountedPrice: Double = 1000.0,
        stock: Int = 120) -> Self {
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
    
    static let sample = [
        ProductEntity.stub(),
        ProductEntity.stub(),
        ProductEntity.stub()]
}
