//
//  TypedProductDetailsRequestDTO.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import Foundation

struct TypedProductDetailsRequestDTO: Encodable {
    let name: String
    let description: String
    let price: Double
    let currency: String
    let discountedPrice: Double?
    let stock: Int?
    let secret: String
}
