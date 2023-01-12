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
    case getProductSecret(_ productID: Int)
    case delete(deleteURI: String)

    var value: String {
        switch self {
        case .products:
            return HTTPPath.basePath
        case .productDetail(let productID):
            return HTTPPath.basePath + "/\(productID)/"
        case .getProductSecret(let productID):
            return HTTPPath.basePath + "/\(productID)/archived"
        case .delete(let deleteURI):
            return "\(deleteURI)"
        }
    }
}

enum HTTPHeader {
    static let identifier = "identifier"
    case delete
    case json
    case multiPartForm(_ boundary: String)

    var header: [String: String] {
        switch self {
        case .delete:
            return [HTTPHeader.identifier: User.identifier]
        case .json:
            return [MIMEType.contentType: MIMEType.applicationJSON,
                    HTTPHeader.identifier: User.identifier]
        case .multiPartForm(let boundary):
            return [MIMEType.contentType: MIMEType.multipartFormData + "\(boundary)",
                    HTTPHeader.identifier: User.identifier]
        }
    }
}
