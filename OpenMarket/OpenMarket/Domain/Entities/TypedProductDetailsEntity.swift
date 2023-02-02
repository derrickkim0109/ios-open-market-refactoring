//
//  TypedProductDetailsEntity.swift
//  OpenMarket
//
//  Created by 데릭
//

import Foundation

struct TypedProductDetailsEntity {
    let name: String
    let description: String
    let price: Double
    let currency: String
    let discountedPrice: Double?
    let stock: Int?
    let secret: String
}

extension TypedProductDetailsEntity {
    func generate() -> ProductPostANDPatchRequestDTO.ProductDTO {
        return ProductPostANDPatchRequestDTO.ProductDTO(
            name: name,
            description: description,
            price: price,
            currency: currency,
            discountedPrice: discountedPrice,
            stock: stock,
            secret: secret)
    }
}
