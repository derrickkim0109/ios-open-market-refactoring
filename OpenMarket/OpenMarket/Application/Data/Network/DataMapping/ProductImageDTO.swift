//
//  ProductImageDTO.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/13.
//

import UIKit

struct ProductImageDTO: Encodable {
    let fileName: String = "image\(arc4random())"
    let data: Data
    let mimeType: String
}

