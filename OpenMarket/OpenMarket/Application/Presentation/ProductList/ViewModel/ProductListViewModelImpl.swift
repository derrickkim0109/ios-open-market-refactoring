//
//  ProductListViewModelImpl.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

final class ProductListViewModelImpl: ViewModel {
    private var service: APIProtocol?

    private var productList: [Product] = []
    private var appendingProuctList: [Product] = []

    enum State {
        case success(data: [ProductEntity])
        case failed(error: Error)
    }

    struct Input {
        let productListTrigger: (pageNumber: Int, itemsPerPage: Int)
    }

    class Output {
        var state: State?
    }

    init(service: APIProtocol) {
        self.service = service
    }

    func transform(input: Input) async -> Output {
        let output = Output()

        do {
            let (pageNumber, itemsPerPage) = input.productListTrigger

            let data = try await fetchData(pageNumber: pageNumber, itemsPerPage: itemsPerPage)
            output.state = .success(data: format(data: data?.pages))

        } catch (let error) {
            output.state = .failed(error: error)
        }

        return output
    }

    private func fetchData(pageNumber: Int, itemsPerPage: Int) async throws -> ProductList? {
        do {
            service = ProductListAPIService(pageNumber: pageNumber, itemsPerPage: itemsPerPage)
            return try await service?.getItems(dataType: ProductList.self)
        } catch (let error) {
            throw error
        }
    }

    private func format(data: [Product]?) -> [ProductEntity] {
        let convertedEntity = data?.compactMap{ $0.generate() }

        guard let convertedEntity else {
            return [ProductEntity]()
        }

        return convertedEntity
    }
}
