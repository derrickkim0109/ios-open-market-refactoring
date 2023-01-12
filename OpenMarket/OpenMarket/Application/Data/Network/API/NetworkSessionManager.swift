//
//  NetworkSessionManager.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

public protocol NetworkSessionManager {
    func request(_ request: URLRequest) async throws -> Data
}

public class DefaultNetworkSessionManager: NetworkSessionManager {
    private let session = URLSession.shared
    public static let shared = DefaultNetworkSessionManager()

    private init() {}
    
    public func request(_ request: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw DataTransferError.noResponse
        }

        return data
    }
}
