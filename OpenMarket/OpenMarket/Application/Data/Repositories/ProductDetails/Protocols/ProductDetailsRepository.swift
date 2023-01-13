//
//  ProductDetailsRepository.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/10.
//

protocol ProductDetailsRepository {
    func fetchProductDetails(productID: Int) async throws -> Endpoint<ProductDetailsRequestDTO>.Response
}
