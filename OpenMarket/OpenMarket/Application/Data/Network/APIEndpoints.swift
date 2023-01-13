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

    static func getProductDetails(_ productID: Int) -> Endpoint<ProductDetailsRequestDTO> {
        return Endpoint(path: HTTPPath.productDetail(productID).value,
                        method: .get)
    }

    static func postProductSecret(_ productID: Int) -> Endpoint<String> {
        return Endpoint(path: HTTPPath.getProductSecret(productID).value,
                        method: .post,
                        headerParameters: HTTPHeader.json.header,
                        bodyParameters: ["secret": User.secret])
    }

    static func deleteProduct(deleteURL: String) -> Endpoint<()> {
        return Endpoint(path: HTTPPath.delete(deleteURI: deleteURL).value,
                        method: .delete,
                        headerParameters: HTTPHeader.delete.header)
    }

    static func patchProduct(_ productID: Int, product: TypedProductDetailsRequestDTO) -> Endpoint<()> {
        return Endpoint(path: HTTPPath.motifyProduct(productID).value,
                        method: .patch,
                        headerParameters: HTTPHeader.json.header,
                        bodyParametersEncodable: product)
    }
}
