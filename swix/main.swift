//
//  main.swift
//  swix
//
//  Created by Scott Sievert on 7/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//


import Foundation
import Swift

_ = swixTests(run_io_tests: true)

_ = swixSpeedTests()

var x = eye(3);
var header = ["1", "2", "3"]

var csv = CSVFile(data:x, header:header)

let filename = "/tmp/test_2016.csv"

write_csv(csv, filename:filename)
var y:CSVFile = read_csv(filename, header_present:true)

//print("\n")
//print(y.data)
//print(y.header)

let a = zeros((3, 7))
let b = arange(3).reshape((3, 1))
let c = a + b
//print(c)

let vec  = vector([1, 2, 3, 4, 5])
print(vec)

let mat = matrix([[1, 2], [3, 4]])
print(mat)



