//
//  ProductListCollectionCellViewModelImpl.swift
//  OpenMarket
//
//  Created by Derrick kim on 2022/12/29.
//

import UIKit

class ProductListCollectionCellViewModelImpl {
    enum Const {
        static let zero = 0
        static let space = " "
        static let colons = " : "
    }
    private let model: ProductEntity

    var thumbnail: String {
        return model.thumbnail
    }

    var name: String {
        return model.name
    }

    var currency: String {
        return model.currency
    }

    var originalPriceText: String {
        return model.currency + Const.space + model.originalPrice.numberFormatter()
    }

    var discountedPriceText: String {
        return model.currency + Const.space + model.discountedPrice.numberFormatter()
    }

    var stockText: String {
        return isEmptyStock == true
            ? ProductStatus.emptyStock
        : ProductStatus.leftOver + Const.colons + "\(model.stock)"
    }

    var isDiscountedItem: Bool {
        return model.originalPrice != model.discountedPrice
    }

    private var isEmptyStock: Bool {
        return model.stock == Const.zero
    }

    var stockTextColor: UIColor {
        return isEmptyStock == true ? .systemYellow : .systemGray
    }

    init(model: ProductEntity) {
        self.model = model
    }
}
