//
//  NetworkProvider.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

struct APIClient {
    private var session: URLSession
    static let shared = APIClient(session: URLSession.shared)
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func requestData(with urlRequest: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidServerResponse
        }

        return data
    }

    func requestData(with url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidServerResponse
        }

        return data
    }
}
