//
//  ProductDetailsRequestDTO.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import Foundation

struct ProductDetailsRequestDTO: Decodable {
    let id: Int
    let vendorId: Int
    let name: String
    let description: String
    let thumbnail: String
    let currency: Currency
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdAt: String
    let issuedAt: String
    let images: [Images]
    let vendors: Vendor
}

extension ProductDetailsRequestDTO {
    func toDomain() -> ProductDetailsEntity {
        return ProductDetailsEntity(
            id: id,
            vendorID: vendorId,
            name: name,
            description: description,
            currency: currency,
            price: price,
            bargainPrice: bargainPrice,
            stock: stock,
            images: productImages)
    }
    
    private var productImages: [String] {
        var array: [String] = []
        
        for image in images {
            array.append(image.url)
        }
        
        return array
    }
}

struct Images: Decodable {
    let id: Int
    let url: String
    let thumbnailUrl: String
    let issuedAt: String
}

struct Vendor: Codable {
    let id: Int
    let name: String
}
