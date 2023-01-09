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

    lazy var apiSecret: String = {
        guard let apiSecret = Bundle.main.object(forInfoDictionaryKey: "Secret") as? String else {
            fatalError("apiSecret must not be empty in plist")
        }
        return apiSecret
    }()

    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "APIBaseURL") as? String else {
            fatalError("APIBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()

    lazy var venderID: String = {
        guard let venderID = Bundle.main.object(forInfoDictionaryKey: "VenderID") as? String else {
            fatalError("venderID must not be empty in plist")
        }
        return venderID
    }()
}
