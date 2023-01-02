//
//  MIMEType.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import Foundation

enum MIMEType {
    static let applicationJSON = "application/json"
    static let multipartFormData = "multipart/form-data; boundary=\(MIMEType.generateBoundary())"
    static let imageJPEG = "image/jpeg"
    static let contentType = "Content-Type"
}

extension MIMEType {
    static func generateBoundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}
