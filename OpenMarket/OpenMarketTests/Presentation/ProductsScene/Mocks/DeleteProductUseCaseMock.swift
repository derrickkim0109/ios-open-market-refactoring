//
//  DeleteProductUseCaseMock.swift
//  OpenMarketTests
//
//  Created by Derrick kim on 2023/01/31.
//

import Foundation

final class DeleteProductUseCaseMock: DeleteProductUseCase {
    var error: Error?
    var result: Void = ()
    
    func execute(
        deleteURL: String) async throws {
            if error == nil {
                return result
            } else {
                throw error ?? DataTransferError.noResponse
            }
        }
}
