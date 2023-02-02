//
//  ProductPostANDPatchRequestDTO+Mapping.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/02/02.
//

import Foundation

struct ProductPostANDPatchRequestDTO: Encodable {
    let parameter: ProductDTO
    let images: [ProductImageDTO]
}

extension ProductPostANDPatchRequestDTO {
    struct ProductDTO: Encodable {
        let name: String
        let description: String
        let price: Double
        let currency: String
        let discountedPrice: Double?
        let stock: Int?
        let secret: String
    }
}

extension ProductPostANDPatchRequestDTO.ProductDTO {
    func toDomain() -> TypedProductDetailsEntity {
        return TypedProductDetailsEntity(
            name: name,
            description: description,
            price: price,
            currency: currency,
            discountedPrice: discountedPrice,
            stock: stock,
            secret: secret)
    }
}

extension ProductPostANDPatchRequestDTO {
    struct ProductImageDTO: Encodable {
        let fileName: String
        let data: Data
        let mimeType: String
    }
}

extension ProductPostANDPatchRequestDTO.ProductImageDTO {
    func toDomain() -> ProductImageEntity {
        return ProductImageEntity(
            data: data,
            mimeType: mimeType)
    }
}
