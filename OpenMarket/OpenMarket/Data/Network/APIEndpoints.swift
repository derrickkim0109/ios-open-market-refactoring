//
//  APIEndpoints.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/09.
//

import Foundation

struct APIEndpoints {
    static func getProducts(
        _ pageNumber: Int,
        _ itemsPerPage: Int) -> Endpoint<ProductsResponseDTO> {
            return Endpoint(
                path: HTTPPath.products.value,
                method: .get,
                queryParameters: [ProductURLQueryItem.page_no: pageNumber,
                                  ProductURLQueryItem.items_per_page: itemsPerPage])
        }
    
    static func getProductDetails(
        _ productID: Int) -> Endpoint<ProductDetailsRequestDTO> {
            return Endpoint(
                path: HTTPPath.productDetail(productID).value,
                method: .get)
        }
    
    static func postProductSecret(
        _ productID: Int) -> Endpoint<String> {
            return Endpoint(
                path: HTTPPath.getProductSecret(productID).value,
                method: .post,
                headerParameters: HTTPHeader.json.header,
                bodyParameters: ["secret": User.secret])
        }
    
    static func postProductEnrollment(
        product: ProductPostANDPatchRequestDTO.ProductDTO,
        images: [ProductPostANDPatchRequestDTO.ProductImageDTO]) -> Endpoint<()>? {
            guard let productData = try? product.toEncode() else {
                return nil
            }
            
            let boundary = "Boundary-\(UUID().uuidString)"
            let multiPartForm = MultiPartForm(
                boundary: boundary,
                data: productData,
                images: images)
            
            return Endpoint(
                path: HTTPPath.products.value,
                method: .post,
                headerParameters: HTTPHeader.multiPartForm(boundary).header,
                bodyParameters: ["":""],
                bodyEncoding: .multipartFormData(multiPartForm))
        }
    
    static func deleteProduct(
        deleteURL: String) -> Endpoint<()> {
            return Endpoint(path: HTTPPath.delete(deleteURI: deleteURL).value,
                            method: .delete,
                            headerParameters: HTTPHeader.delete.header)
        }
    
    static func patchProduct(
        _ productID: Int,
        product: ProductPostANDPatchRequestDTO.ProductDTO) -> Endpoint<()> {
            return Endpoint(
                path: HTTPPath.motifyProduct(productID).value,
                method: .patch,
                headerParameters: HTTPHeader.json.header,
                bodyParametersEncodable: product)
        }
}
