//
//  NetworkService.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/04.
//

import Foundation

public protocol NetworkService {
    @discardableResult
    func request(endpoint: Requestable) async throws -> Data
}

public final class DefaultNetworkService: NetworkService {
    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager

    public init(config: NetworkConfigurable,
                sessionManager: NetworkSessionManager = DefaultNetworkSessionManager.shared) {
        self.config = config
        self.sessionManager = sessionManager
    }

    public func request(endpoint: Requestable) async throws -> Data {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            return try await sessionManager.request(urlRequest)
        } catch {
            throw NetworkError.urlGeneration
        }
    }
}
