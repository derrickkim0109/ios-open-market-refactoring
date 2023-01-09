//
//  APIEndpoints.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/09.
//

import Foundation

struct APIEndpoints {
    static func getProducts(_ pageNumber: Int,_ itemsPerPage: Int) -> Endpoint<ProductsRequestDTO> {
        return Endpoint(path: HTTPPath.products.value,
                        method: .get,
                        queryParameters: ["page_no": pageNumber,
                                          "items_per_page": itemsPerPage])
    }
}
