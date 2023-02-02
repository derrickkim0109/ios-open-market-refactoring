//
//  ProductsRepository.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/09.
//

protocol ProductsRepository {
    func fetchProductsList(
        page: Int,
        itemsPerPage: Int) async throws -> Endpoint<ProductsResponseDTO>.Response
}

