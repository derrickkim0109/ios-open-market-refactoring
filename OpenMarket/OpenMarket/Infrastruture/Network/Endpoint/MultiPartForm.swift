//
//  MultiPartForm.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/14.
//

import Foundation

struct MultiPartForm {
    let boundary: String
    let data: Data
    let images: [ProductPostANDPatchRequestDTO.ProductImageDTO]
}

enum BodyEncoding {
    case jsonSerializationData
    case multipartFormData(_ form: MultiPartForm)
    case stringEncodingAscii

    private static let lineBreak = "\r\n"
    private static let doubleMinus = "--"
    private static let colons = ":"
    private static let params = "params"
    private static let images = "images"
}

extension BodyEncoding {
    static func createMultiPartFormBody(
        form: MultiPartForm) -> Data {
        let productData = createData(
            boundary: form.boundary,
            json: form.data)

        var data = Data()
        data.append(productData)

        form.images.forEach {
            let imageData = createData(
                boundary: form.boundary,
                image: $0)

            data.append(imageData)
        }

        data.append("\(lineBreak)--\(form.boundary)--\(lineBreak)")
        return data
    }

    private static func createData(
        boundary: String,
        json: Data) -> Data {
        var data = Data()
        data.append("\(lineBreak)--\(boundary + lineBreak)")
        data.append("Content-Disposition: form-data; name=\"params\"\(lineBreak)")
        data.append("Content-Type: application/json \(lineBreak + lineBreak)")
        data.append(json)
        return data
    }

    private static func createData(
        boundary: String,
        image: ProductPostANDPatchRequestDTO.ProductImageDTO) -> Data {
        let fileName = image.fileName + "." + image.mimeType
        let fileType = "image/\(image.mimeType)"

        var data = Data()
        data.append("\(lineBreak)--\(boundary + lineBreak)")
        data.append("Content-Disposition: form-data; name=\"images\"; filename=\"\(fileName)\"\(lineBreak)")
        data.append("Content-Type: \(fileType) \(lineBreak + lineBreak)")
        data.append(image.data)
        return data
    }
}

fileprivate extension Data {
    mutating func append(
        _ text: String) {
        guard let data = text.data(
            using: .utf8) else {
            return
        }
        
        append(data)
    }
}
