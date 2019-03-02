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

var x = eye(3);
var header = ["1", "2", "3"]

var csv = CSVFile(data:x, header:header)

let filename = "/tmp/test_2016.csv"

write_csv(csv, filename:filename)
var y:CSVFile = read_csv(filename, header_present:true)

let m1 = matrix([[3, 0],
                 [2, 1]])

print(argmax(m1, axis: 0))
print(argmax(m1, axis: 1))
