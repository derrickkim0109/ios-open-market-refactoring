//
//  ProductDetailsViewModel.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

final class ProductDetailsViewModel {
    // MARK: Properties
    
    private var productDetailsEntity: ProductDetailsEntity?
    private var productDetails: ProductDetails?
    private var currentPage: Int?
    
    weak var delegate: ProductDetailsViewDelegate?
    
    // MARK: - Initializer
    init() {}
    
    init(productDetailEntity: ProductDetailsEntity) {
        self.productDetailsEntity = productDetailEntity
    }
    
    var productName: String? {
        guard let productDetailsEntity = productDetailsEntity else {
            return nil
        }
        
        return productDetailsEntity.name
    }
    
    var currency: String? {
        guard let productDetailsEntity = productDetailsEntity else {
            return nil
        }
        
        return productDetailsEntity.currency.rawValue
    }
    
    var originalPriceText: String? {
        guard let productDetailsEntity = productDetailsEntity,
              let originalPriceText = productDetailsEntity.price.numberFormatter() else {
            return nil
        }
        
        return productDetailsEntity.currency.rawValue + " " + originalPriceText
    }
    
    var discountedPriceText: String? {
        guard let productDetail = productDetailsEntity,
        let discountedPriceText = productDetail.bargainPrice.numberFormatter() else {
            return nil
        }
        
        return productDetail.currency.rawValue + " " + discountedPriceText
    }
    
    var stockText: String? {
        guard let productDetail = productDetailsEntity else {
            return nil
        }
        
        return isEmptyStock == true
        ? ProductStatus.emptyStock.rawValue
        : ProductStatus.leftOver.rawValue + " : \(productDetail.stock)"
    }
    
    var description: String? {
        guard let productDetail = productDetailsEntity else {
            return nil
        }
        
        return productDetail.description
    }
    
    var isDiscountedItem: Bool? {
        guard let productDetail = productDetailsEntity else {
            return nil
        }
        
        return productDetail.price != productDetail.bargainPrice
    }
    
    var isEmptyStock: Bool? {
        guard let productDetail = productDetailsEntity else {
            return nil
        }
        
        return productDetail.stock == 0
    }
    
    var numberOfImages: String? {
        if let images = productDetails?.images,
           let currentPage = currentPage {
            return "\(currentPage)/\(images.count)"
        }
        return nil
    }
    
    func returnCurrentpage(_ index: Int){
        currentPage = index
    }
    
    func format(productDetails: ProductDetails) {
        self.productDetails = productDetails
        
        guard let productImages = productDetails.productImages else {
            return
        }
        
        let productInfo = ProductDetailsEntity(id: productDetails.id,
                                               vendorID: productDetails.vendorId,
                                               name: productDetails.name,
                                               description: productDetails.description,
                                               currency: productDetails.currency,
                                               price: productDetails.price,
                                               bargainPrice: productDetails.bargainPrice,
                                               stock: productDetails.stock,
                                               images: productImages)
        
        delegate?.productDetailsViewController(ProductDetailsViewController.self,
                                               didRecieve: productImages)
        delegate?.productDetailsViewController(ProductDetailsViewController.self,
                                               didRecieve: productInfo)
    }
    
    func fetch(productSecret: String) {
        delegate?.productDetailsViewController(ProductDetailsViewController.self,
                                               didRecieve: productSecret)
    }
}
