//
//  ArrayExstensions.swift
//  swix-mac
//
//  Created by Vasiliy Dumanov on 3/1/19.
//  Copyright © 2019 com.scott. All rights reserved.
//

import Foundation

public extension Array {
    public func chunked(minSize size: Int) -> [[Element]] {
        var arr = chunked(maxSize: size)
        if arr[arr.count - 1].count < size {
            arr[arr.count - 2] += arr[arr.count - 1]
            arr.removeLast()
        }
        return arr
    }
    
    public func chunked(maxSize size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            return Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
