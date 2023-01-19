//
//  JSONResponseDecoder.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/04.
//

import Foundation

protocol ResponseDecoder {
    func decode<T: Decodable>(from data: Data) async throws -> T
}

final class JSONResponseDecoder: ResponseDecoder {
    private let decoder = JSONDecoder()
    init() {}

    func decode<T: Decodable>(from data: Data) async throws -> T {
        do {
            if T.self == String.self {
                return String(data: data, encoding: .utf8) as! T
            }

            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            switch error {
            case DecodingError.typeMismatch(let type, let context):
                throw JSONDecodingError.typeMismatch(type: type, context: context)
            case DecodingError.dataCorrupted(let context):
                throw JSONDecodingError.dataCorrupted(context: context)
            case DecodingError.valueNotFound(let type , let context):
                throw JSONDecodingError.valueNotFound(type: type, context: context)
            case DecodingError.keyNotFound(let type , let context):
                throw JSONDecodingError.keyNotFound(type: type, context: context)
            default:
                throw error
            }
        }
    }
}

enum JSONDecodingError: LocalizedError {
    case typeMismatch(type: Any.Type, context: DecodingError.Context)
    case dataCorrupted(context: DecodingError.Context)
    case valueNotFound(type: Any.Type, context: DecodingError.Context)
    case keyNotFound(type: CodingKey, context: DecodingError.Context)

    var errorDescription: String? {
        switch self {
        case .typeMismatch(let type, let context):
            return "\(type.self) ERROR - \(context.debugDescription)"
        case .dataCorrupted(let context):
            return context.debugDescription
        case .valueNotFound(_ , let context):
            return context.debugDescription
        case .keyNotFound(_ , let context):
            return context.debugDescription
        }
    }
}
