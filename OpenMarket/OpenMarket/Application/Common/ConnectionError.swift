//
//  ConnectionError.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/27.
//

import Foundation

public protocol ConnectionError: Error {
    var isInternetConnectionError: Bool { get }
}

public extension Error {
    var isInternetConnectionError: Bool {
        guard let error = self as? ConnectionError,
              error.isInternetConnectionError else {
            return false
        }
        
        return true
    }
}
