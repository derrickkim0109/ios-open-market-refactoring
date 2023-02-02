//
//  ProductImageEntityDTO+Stub.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/31.
//

import Foundation

extension ProductImageEntity {
    static func stub(
        data: Data = Data(),
        mimeType: String = "png"
    ) -> Self {
        return ProductImageEntity(data: data,
                                  mimeType: mimeType)
    }
    
    static let sample = [
        ProductImageEntity.stub(),
        ProductImageEntity.stub(),
        ProductImageEntity.stub()
    ]
}

