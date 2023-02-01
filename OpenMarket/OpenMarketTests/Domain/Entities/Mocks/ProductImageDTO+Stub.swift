//
//  ProductImageDTO+Stub.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/31.
//

import Foundation

extension ProductImageDTO {
    static func stub(
        data: Data = Data(),
        mimeType: String = "png"
    ) -> Self {
        return ProductImageDTO(data: data,
                               mimeType: mimeType)
    }

    static let sample = [
        ProductImageDTO.stub(),
        ProductImageDTO.stub(),
        ProductImageDTO.stub()
    ]
}

