//
//  HTTPMethod.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

public enum HTTPMethodType: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

public enum BodyEncoding {
    case jsonSerializationData
    case stringEncodingAscii
}

enum HTTPPath {
    static let basePath = "/api/products"
    case products
    case productDetail(_ productID: Int)
    case getDeleteURI(_ productID: Int)
    case delete(_ deleteURL: String)

    var value: String {
        switch self {
        case .products:
            return HTTPPath.basePath
        case .productDetail(let productID):
            return HTTPPath.basePath + "/\(productID)/"
        case .getDeleteURI(let productID):
            return HTTPPath.basePath + "/\(productID)/archived"
        case .delete(let deleteURI):
            return"\(deleteURI)"
        }
    }
}
