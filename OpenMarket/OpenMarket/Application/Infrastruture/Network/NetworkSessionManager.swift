//
//  NetworkSessionManager.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

protocol NetworkSessionManager {
    func request(_ request: URLRequest) async throws -> Data
}

final class DefaultNetworkSessionManager: NetworkSessionManager {
    private let session = URLSession.shared
    static let shared = DefaultNetworkSessionManager()

    private init() {}
    
    func request(_ request: URLRequest) async throws -> Data {
        do {
            let (data, response) = try await session.data(for: request)

            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode != 200 {
                guard httpResponse.statusCode != 202 else {
                    return data
                }

                throw NetworkError.error(statusCode: httpResponse.statusCode, data: data)
            }

            return data
        } catch (let error) {
            throw resolve(error: error)
        }
    }

    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
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
