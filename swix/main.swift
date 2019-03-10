//
//  main.swift
//  swix
//
//  Created by Scott Sievert on 7/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//


import Foundation
import Swift


let mats: [matrix] = [
    matrix([[1.0, 1.0],
            [2.0, 2.0]]),
    matrix([[3.0, 3.0],
            [4.0, 4.0]])
]

print(hstack(mats))
print(vstack(mats))
