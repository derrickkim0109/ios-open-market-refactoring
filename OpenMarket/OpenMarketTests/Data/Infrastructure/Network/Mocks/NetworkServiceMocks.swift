//
//  NetworkServiceMocks.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/24.
//

import Foundation

struct NetworkConfigurableMock: NetworkConfigurable {
    var baseURL: URL = URL(
        string: "https://openmarket.yagom-academy.kr")!
    
    var headers: [String: String] = [:]
    var queryParameters: [String: String] = [:]
}
