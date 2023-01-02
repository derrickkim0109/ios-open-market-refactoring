//
//  APIError.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import Foundation

enum APIError: LocalizedError {
    case unknown
    case invalidURLString
    case invalidServerResponse
    case jsonFileNotFound
    case emptyData

    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "알 수 없는 에러입니다."
        case .invalidURLString:
            return "유효하지 않는 URL입니다."
        case .invalidServerResponse:
            return "유효하지 않는 통신 오류입니다."
        case .jsonFileNotFound:
            return "JSON파일을 찾을 수 없습니다."
        case .emptyData:
            return "데이터가 없습니다."
        }
    }
}
