//
//  ProductImageEntity.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/13.
//

import UIKit

struct ProductImageEntity {
    let fileName: String = "image\(arc4random()).jpeg"
    let data: Data
    let mimeType: String
}

extension ProductImageEntity {
    func generate() -> ProductPostANDPatchRequestDTO.ProductImageDTO {
        return ProductPostANDPatchRequestDTO.ProductImageDTO(
            fileName: fileName,
            data: data,
            mimeType: mimeType)
    }
}
