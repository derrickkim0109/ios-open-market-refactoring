//
//  AnyCancellableTask.swift
//  OpenMarket
//
//  Created by Derrick kim on 2023/01/19.
//

public protocol AnyCancellableTask {
    func cancel()
}

extension Task: AnyCancellableTask {}
