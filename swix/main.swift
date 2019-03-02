//
//  main.swift
//  swix
//
//  Created by Scott Sievert on 7/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//


import Foundation
import Swift

//_ = swixTests(run_io_tests: true)
//
//_ = swixSpeedTests()

let m1 = matrix([[3, 0],
                 [2, 1]])

print(m1.max(0))
print(m1.max(1))
