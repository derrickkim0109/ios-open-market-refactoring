//
//  Product+Stub.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/29.
//

import Foundation

extension Product {
    static func stub(
        id: Int,
        vendorId: Int = 12,
        name: String = "삼푸1",
        thumbnail: String = "shampoo.png",
        currency: Currency = .krw,
        price: Double = 1000.0,
        bargainPrice: Double = 0.0,
        discountedPrice: Double = 100.0,
        stock: Int = 40,
        createdAt: String = "2022-01-13",
        issuedAt: String = "2022-01-13") -> Self {
            return Product(
                id: id,
                vendorId: vendorId,
                name: name,
                thumbnail: thumbnail,
                currency: currency,
                price: price,
                bargainPrice: bargainPrice,
                discountedPrice: discountedPrice,
                stock: stock,
                createdAt: createdAt,
                issuedAt: issuedAt)
        }
    
    static let list = [
        Product.stub(
            id: 1),
        Product.stub(
            id: 2),
        Product.stub(
            id: 3),
        Product.stub(
            id: 4),
        Product.stub(
            id: 5),
        Product.stub(
            id: 6),
        Product.stub(
            id: 7),
        Product.stub(
            id: 8)
    ]
}
