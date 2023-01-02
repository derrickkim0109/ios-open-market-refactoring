//
//  APIProtocol.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import Foundation

protocol APIProtocol {
    var configuration: APIConfiguration { get }
}

extension APIProtocol {
    func getItems<T: Decodable>(dataType: T.Type,
                                using client: APIClient = APIClient.shared) async throws -> T {
        var urlRequest = URLRequest(url: configuration.url)
        urlRequest.httpMethod = HTTPMethod.get
        
        do {
            let data = try await client.requestData(with: urlRequest)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            let decodedData = try decoder.decode(T.self,
                                                 from: data)
            return decodedData
        } catch {
            throw APIError.emptyData
        }
    }
}
