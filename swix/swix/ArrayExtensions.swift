//
//  ArrayExstensions.swift
//  swix-mac
//
//  Created by Vasiliy Dumanov on 3/1/19.
//  Copyright © 2019 com.scott. All rights reserved.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
