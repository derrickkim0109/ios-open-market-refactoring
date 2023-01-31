//
//  ProductImageDTO+Stub.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/31.
//

import Foundation

extension ProductImageDTO {
    static func stub(
        data: Data,
        mimeType: String
    ) -> Self {
        return ProductImageDTO(data: data,
                               mimeType: mimeType)
    }
}

