//
//  ViewModel.swift
//  OpenMarket
//
//  Created by Derrick kim on 2022/12/30.
//

import Foundation

public protocol ViewModel: ObservableObject {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) async -> Output
}
