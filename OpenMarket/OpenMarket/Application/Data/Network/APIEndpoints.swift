//
//  APIEndpoints.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/09.
//

import Foundation

struct APIEndpoints {
    static func getProducts(_ pageNumber: Int,_ itemsPerPage: Int) -> Endpoint<ProductsResponseDTO> {
        return Endpoint(path: HTTPPath.products.value,
                        method: .get,
                        queryParameters: [ProductURLQueryItem.page_no: pageNumber,
                                          ProductURLQueryItem.items_per_page: itemsPerPage])
    }

    static func getProductDetails(_ productID: Int) -> Endpoint<ProductDetailsResponseDTO> {
        return Endpoint(path: HTTPPath.productDetail(productID).value,
                        method: .get)
    }
}
