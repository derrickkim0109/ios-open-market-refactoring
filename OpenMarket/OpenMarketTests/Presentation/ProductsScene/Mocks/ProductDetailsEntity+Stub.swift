//
//  ProductDetailsEntity+Stub.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/02/01.
//

import Foundation

extension ProductDetailsEntity {
    static func stub(
        id: Int = 1,
        vendorID: Int = 12,
        name: String = "애플 맥북",
        description: String = "미국산",
        currency: Currency = .krw,
        price: Double = 1000000.0,
        bargainPrice: Double = 1000.0,
        stock: Int = 30,
        images: [String]) -> Self {
            return ProductDetailsEntity(
                id: id,
                vendorID: vendorID,
                name: name,
                description: description,
                currency: currency,
                price: price,
                bargainPrice: bargainPrice,
                stock: stock,
                images: images)
        }
    
    static let sample = ProductDetailsEntity.stub(
        images: ["apple.png", "iphone.png"])
}


