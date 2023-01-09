//
//  DataTransferService.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/09.
//

import Foundation

public protocol DataTransferService {
    @discardableResult
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E) async throws -> T  where E.Response == T
    func request<E: ResponseRequestable>(with endpoint: E) async throws where E : ResponseRequestable, E.Response == ()
}

public final class DefaultDataTransferService {
    private let networkService: NetworkService

    public init(with networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultDataTransferService: DataTransferService {
    @MainActor
    public func request<T: Decodable, E: ResponseRequestable>(with endpoint: E) async throws -> T {
        do {
            let data = try await networkService.request(endpoint: endpoint)
            let result: T = try await self.decode(data: data, decoder: endpoint.responseDecoder)
            return result
        } catch (let error) {
            throw error
        }
    }

    @MainActor
    public func request<E>(with endpoint: E) async throws where E : ResponseRequestable, E.Response == () {
        do {
            try await networkService.request(endpoint: endpoint)
        } catch (let error) {
            throw error
        }
    }

    private func decode<T: Decodable>(data: Data?, decoder: ResponseDecoder) async throws -> T {
        do {
            guard let data = data else { throw DataTransferError.noResponse }
            return try await decoder.decode(from: data)
        } catch (let error) {
            throw DataTransferError.parsing(error)
        }
    }
}
