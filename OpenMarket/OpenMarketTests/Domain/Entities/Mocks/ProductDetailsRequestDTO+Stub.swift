//
//  ProductDetailsRequestDTO+Stub.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/31.
//

import Foundation

extension ProductDetailsRequestDTO {
    static func stub(id: Int = 1,
                     vendorId: Int = 12,
                     name: String = "맥북",
                     description: String = "애플 맥북",
                     thumbnail: String = "apple.png",
                     currency: Currency = .krw,
                     price: Double = 1000000.0,
                     bargainPrice: Double = 0.0,
                     discountedPrice: Double = 1000.0,
                     stock: Int = 120,
                     createdAt: String = "2022-02-01",
                     issuedAt: String = "2022-02-01",
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
        images: [Images(id: 1,
                        url: "www.test.com",
                        thumbnailUrl: "test",
                        issuedAt: "2022-02-01")],
        vendors: Vendor(id: 12,
                        name: "주인이름"))
}
