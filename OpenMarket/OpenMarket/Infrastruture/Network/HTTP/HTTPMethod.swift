//
//  HTTPMethod.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

enum RequestName {
    static let initialPageNumber = 1
    static let initialItemPerPage = 10
}

enum ProductURLQueryItem {
    static let page_no = "page_no"
    static let items_per_page = "items_per_page"
}

enum HTTPMethod: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

enum HTTPPath {
    static let basePath = "/api/products"
    case products
    case productDetail(_ productID: Int)
    case getProductSecret(_ productID: Int)
    case motifyProduct(_ productID: Int)
    case delete(deleteURI: String)

    var value: String {
        switch self {
        case .products:
            return HTTPPath.basePath
        case .productDetail(let productID):
            return HTTPPath.basePath + "/\(productID)/"
        case .getProductSecret(let productID):
            return HTTPPath.basePath + "/\(productID)/archived"
        case .motifyProduct(let productID):
            return HTTPPath.basePath + "/\(productID)/"
        case .delete(let deleteURI):
            return "\(deleteURI)"
        }
    }
}

enum HTTPHeader {
    private static let identifier = "identifier"
    private static let applicationJSON = "application/json"
    private static let multipartFormData = "multipart/form-data; boundary="
    private static let contentType = "Content-Type"

    case delete
    case json
    case multiPartForm(_ boundary: String)

    var header: [String: String] {
        switch self {
        case .delete:
            return [HTTPHeader.identifier: User.identifier]
        case .json:
            return [HTTPHeader.contentType: HTTPHeader.applicationJSON,
                    HTTPHeader.identifier: User.identifier]
        case .multiPartForm(let boundary):
            return [HTTPHeader.contentType: HTTPHeader.multipartFormData + boundary,
                    HTTPHeader.identifier: User.identifier]
        }
    }
}
