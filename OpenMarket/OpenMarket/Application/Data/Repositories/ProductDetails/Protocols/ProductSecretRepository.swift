//
//  ProductSecretRepository.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/12.
//

protocol ProductSecretRepository {
    func fetchProductSecret(
        productID: Int) async throws -> Endpoint<String>.Response
}
