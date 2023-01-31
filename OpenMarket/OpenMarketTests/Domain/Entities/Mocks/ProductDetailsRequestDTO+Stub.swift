//
//  ProductDetailsRequestDTO+Stub.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/31.
//

import Foundation

extension ProductDetailsRequestDTO {
    static func stub(id: Int,
                     vendorId: Int,
                     name: String,
                     description: String,
                     thumbnail: String,
                     currency: Currency,
                     price: Double,
                     bargainPrice: Double,
                     discountedPrice: Double,
                     stock: Int,
                     createdAt: String,
                     issuedAt: String,
                     images: [Images],
                     vendors: Vendor) -> Self {
        return ProductDetailsRequestDTO(
            id: id,
            vendorId: vendorId,
            name: name,
            description: description,
            thumbnail: thumbnail,
            currency: currency,
            price: price,
            bargainPrice: bargainPrice,
            discountedPrice: discountedPrice,
            stock: stock,
            createdAt: createdAt,
            issuedAt: issuedAt,
            images: images,
            vendors: vendors)
    }

    static let productInfo = ProductDetailsRequestDTO.stub(
        id: 1,
        vendorId: 12,
        name: "맥북",
        description: "애플 맥북",
        thumbnail: "apple.png",
        currency: .krw,
        price: 1000000.0,
        bargainPrice: 0,
        discountedPrice: 1000.0,
        stock: 120,
        createdAt: "2022-02-01",
        issuedAt: "2022-02-01",
        images: [Images(id: 1,
                        url: "www.test.com",
                        thumbnailUrl: "test",
                        issuedAt: "2022-02-01")],
        vendors: Vendor(id: 11,
                        name: "주인이름"))
}
