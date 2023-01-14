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
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode >= 200, httpResponse.statusCode < 300
        else {
            throw DataTransferError.noResponse
        }

        return data
    }
}
