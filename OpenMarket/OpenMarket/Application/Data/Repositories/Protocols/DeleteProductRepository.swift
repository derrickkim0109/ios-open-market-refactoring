//
//  DeleteProductRepository.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/12.
//

protocol DeleteProductRepository {
    func deleteProduct(deleteURI: String) async throws
}
