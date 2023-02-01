//
//  FetchProductDetailsUseCaseMock.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/31.
//

import Foundation

final class FetchProductDetailsUseCaseMock: FetchProductDetailsUseCase {
    var error: Error?
    var productInfo = ProductDetailsRequestDTO(
        id: 0,
        vendorId: 0,
        name: "",
        description: "",
        thumbnail: "",
        currency: .krw,
        price: 0.0,
        bargainPrice: 0.0,
        discountedPrice: 0.0,
        stock: 0,
        createdAt: "",
        issuedAt: "",
        images: [],
        vendors: Vendor(id: 0, name: ""))
    
    func execute(
        productID: Int) async throws -> ProductDetailsRequestDTO {
            if error == nil {
                return productInfo
            } else {
                throw error ?? DataTransferError.noResponse
            }
        }
}
