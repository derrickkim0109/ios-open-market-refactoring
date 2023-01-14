//
//  TypedProductDetailsRequestDTO.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import Foundation

struct TypedProductDetailsRequestDTO: Encodable {
    let name: String?
    let descriptions: String?
    let price: Double?
    let currency: Currency?
    let discountedPrice: Double?
    let stock: Int?
    let secret: String
}
