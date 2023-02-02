//
//  ProductsResponseDTO.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import Foundation

struct ProductsResponseDTO: Decodable {
    let pageNo: Int
    let itemsPerPage: Int
    let pages: [Product]
}

enum Currency: String, Codable {
    case krw = "KRW"
    case usd = "USD"
}

struct Product: Decodable {
    let id: Int
    let vendorId: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdAt: String
    let issuedAt: String
}

extension Product {
    func toDomain() -> ProductEntity {
        return ProductEntity(
            id: id,
            vendorID: vendorId,
            thumbnail: thumbnail,
            name: name,
            currency: currency.rawValue,
            originalPrice: price,
            discountedPrice: bargainPrice,
            stock: stock)
    }
}
