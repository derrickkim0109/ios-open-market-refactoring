//
//  AppDIContainer.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/07.
//

import Foundation

final class AppDIContainer {
    lazy var appConfiguration = AppConfiguration()

    lazy var apiDataTransferService: DataTransferService = {
        let configuration = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!)

        let apiDataNetwork = DefaultNetworkService(config: configuration)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()

    func makeProductsSceneDIContainer() -> ProductsSceneDIContainer {
        let dependencies = ProductsSceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService)
        return ProductsSceneDIContainer(dependencies: dependencies)
    }
}
