//
//  NetworkSessionManagerMock.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/24.
//

import Foundation

struct NetworkSessionManagerMock: NetworkSessionManager {
    let response: HTTPURLResponse?
    let data: Data?
    let error: Error?
    
    func request(
        _ request: URLRequest) async throws -> Data? {
            if let statusCode = response?.statusCode,
               statusCode != 200 {
                guard statusCode != 202 else {
                    return data!
                }
                
                throw NetworkError.error(
                    statusCode: statusCode, data: data)
            }
            
            if let error = error {
                throw resolve(
                    error: error)
            }
            
            return data
        }
    
    private func resolve(
        error: Error) -> NetworkError {
            let code = URLError.Code(
                rawValue: (error as NSError).code)
            
            switch code {
            case .notConnectedToInternet:
                return .notConnected
            case .cancelled:
                return .cancelled
            default:
                return .generic(error)
            }
        }
}
