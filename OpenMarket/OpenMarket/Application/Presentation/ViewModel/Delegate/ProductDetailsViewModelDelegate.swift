//
//  ProductDetailsViewModelDelegate.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

protocol ProductDetailsViewModelDelegate: AnyObject {
    func productDetailViewModel(_ viewModel: ProductDetailsViewModel.Type,
                            didRecieve images: [UIImage])
    func productDetailViewModel(_ viewModel: ProductDetailsViewModel.Type,
                            didRecieve productInfo: ProductDetailsEntity)
    func productDetailViewModel(_ viewModel: ProductDetailsViewModel.Type,
                            didRecieve productSecret: String)
}
