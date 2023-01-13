//
//  AppConfiguration.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/07.
//

import Foundation

final class AppConfiguration {
    lazy var apiKey: String = {
        guard let apiID = Bundle.main.object(forInfoDictionaryKey: "APIID") as? String else {
            fatalError("APIID must not be empty in plist")
        }
        return apiKey
    }()

    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "APIBaseURL") as? String else {
            fatalError("APIBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
}
