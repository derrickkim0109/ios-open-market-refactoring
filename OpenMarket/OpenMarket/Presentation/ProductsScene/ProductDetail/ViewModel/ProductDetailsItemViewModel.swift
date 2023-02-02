//
//  ProductDetailsItemViewModel.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/11.
//

import Foundation

final class ProductDetailsItemViewModel {
    private let model: ProductDetailsEntity
    
    init(
        model: ProductDetailsEntity) {
        self.model = model
    }
    
    func returnTotalPage(
        _ index: Int) -> String {
        return "\(index)/\(model.images.count)"
    }
}
