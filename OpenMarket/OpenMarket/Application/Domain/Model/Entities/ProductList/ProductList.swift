//
//  ProductList.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

struct ProductList: Codable {
    let pages: [Product]
}

enum Currency: String, Codable {
    case krw = "KRW"
    case usd = "USD"
}

struct Product: Codable {
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
