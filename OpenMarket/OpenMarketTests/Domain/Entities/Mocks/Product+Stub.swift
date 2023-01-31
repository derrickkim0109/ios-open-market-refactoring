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
        vendorId: Int,
        name: String,
        thumbnail: String,
        currency: Currency,
        price: Double,
        bargainPrice: Double,
        discountedPrice: Double,
        stock: Int,
        createdAt: String,
        issuedAt: String) -> Self {
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
            id: 1,
            vendorId: 12,
            name: "샴푸1",
            thumbnail: "shampo",
            currency: .krw,
            price: 1000.0,
            bargainPrice: 0.0,
            discountedPrice: 100.0,
            stock: 40,
            createdAt: "2022-01-13",
            issuedAt: "2022-01-13"),
        Product.stub(
            id: 2,
            vendorId: 12,
            name: "샴푸2",
            thumbnail: "shampo",
            currency: .krw,
            price: 1000.0,
            bargainPrice: 0.0,
            discountedPrice: 100.0,
            stock: 40,
            createdAt: "2022-01-13",
            issuedAt: "2022-01-13"),
        Product.stub(
            id: 3,
            vendorId: 12,
            name: "샴푸3",
            thumbnail: "shampo",
            currency: .krw,
            price: 1000.0,
            bargainPrice: 0.0,
            discountedPrice: 100.0,
            stock: 40,
            createdAt: "2022-01-13",
            issuedAt: "2022-01-13"),
        Product.stub(
            id: 4,
            vendorId: 12,
            name: "샴푸4",
            thumbnail: "shampo",
            currency: .krw,
            price: 1000.0,
            bargainPrice: 0.0,
            discountedPrice: 100.0,
            stock: 40,
            createdAt: "2022-01-13",
            issuedAt: "2022-01-13"),
        Product.stub(
            id: 5,
            vendorId: 12,
            name: "샴푸5",
            thumbnail: "shampo",
            currency: .krw,
            price: 1000.0,
            bargainPrice: 0.0,
            discountedPrice: 100.0,
            stock: 40,
            createdAt: "2022-01-13",
            issuedAt: "2022-01-13"),
        Product.stub(
            id: 6,
            vendorId: 12,
            name: "샴푸6",
            thumbnail: "shampo",
            currency: .krw,
            price: 1000.0,
            bargainPrice: 0.0,
            discountedPrice: 100.0,
            stock: 40,
            createdAt: "2022-01-13",
            issuedAt: "2022-01-13"),
        Product.stub(
            id: 7,
            vendorId: 12,
            name: "샴푸7",
            thumbnail: "shampo",
            currency: .krw,
            price: 1000.0,
            bargainPrice: 0.0,
            discountedPrice: 100.0,
            stock: 40,
            createdAt: "2022-01-13",
            issuedAt: "2022-01-13"),
        Product.stub(
            id: 8,
            vendorId: 12,
            name: "샴푸8",
            thumbnail: "shampo",
            currency: .krw,
            price: 1000.0,
            bargainPrice: 0.0,
            discountedPrice: 100.0,
            stock: 40,
            createdAt: "2022-01-13",
            issuedAt: "2022-01-13")
    ]
}
