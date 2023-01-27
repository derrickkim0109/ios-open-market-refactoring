//
//  ModifyProductRepository.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/13.
//

protocol ModifyProductRepository {
    func modifyProduct(productID: Int,
                       product: TypedProductDetailsRequestDTO) async throws -> Endpoint<()>.Response
}
