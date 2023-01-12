//
//  MIMEType.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import Foundation

enum MIMEType {
    static let applicationJSON = "application/json"
    static let multipartFormData = "multipart/form-data; boundary="
    static let imageJPEG = "image/jpeg"
    static let contentType = "Content-Type"
    static let contentDisPosition = "Content-Disposition"
}

enum MultipartForm {
    private static let lineBreak = "\r\n"
    private static let doubleMinus = "--"
    private static let colons = ":"
    private static let params = "params"
    private static let images = "images"

    static func createData(withParameters parameters: EnrollProductEntity,
                           boundary: String) -> Data {
        var body = Data()
        let params = parameters.parameter
        let media = parameters.images

        body.append(doubleMinus + boundary + lineBreak)
        body.append(MIMEType.contentDisPosition + colons + " form-data; name=\"\(params)\"\(lineBreak + lineBreak)")
        body.append(params.convertData())
        body.append(lineBreak)

        for photo in media {
            body.append(doubleMinus + boundary + lineBreak)
            body.append(MIMEType.contentDisPosition + ": form-data; name=\"\(images)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
            body.append(MIMEType.contentType + ": \(photo.mimeType + lineBreak + lineBreak)")
            body.append(photo.data)
            body.append(lineBreak)
        }

        body.append(doubleMinus + boundary + doubleMinus + lineBreak)

        return body
    }
}

fileprivate extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
