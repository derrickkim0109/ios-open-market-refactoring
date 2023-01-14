//
//  NetworkError.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/09.
//

import Foundation

enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}
