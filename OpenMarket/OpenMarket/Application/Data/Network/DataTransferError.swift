//
//  DataTransferError.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/09.
//

import Foundation

enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(Error)
    case resolvedNetworkFailure(Error)
}
