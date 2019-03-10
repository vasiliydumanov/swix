//
//  twoD-operators.swift
//  swix
//
//  Created by Scott Sievert on 7/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation
import Accelerate

private func equalizeShapes(_ lhs: matrix, rhs: matrix) -> (lhs: vector, rhs: vector, shape: (Int, Int)) {
    assert(lhs.shape.0 == rhs.shape.0 || lhs.shape.0 == 1 || rhs.shape.0 == 1, "0-axes size must match or be equal to 1.")
    assert(lhs.shape.1 == rhs.shape.1 || lhs.shape.1 == 1 || rhs.shape.1 == 1, "1-axes size must match or be equal to 1.")
    
    let lhsV: vector
    let rhsV: vector
    let resShape: (Int, Int)
    switch (lhs.shape.0 == rhs.shape.0, lhs.shape.1 == rhs.shape.1) {
    case (true, true):
        lhsV = lhs.flat
        rhsV = rhs.flat
        resShape = lhs.shape
    case (true, false):
        if lhs.shape.1 == 1 {
            lhsV = `repeat`(lhs.flat, N: rhs.shape.1, axis: 1)
            rhsV = rhs.flat
            resShape = rhs.shape
        } else {
            rhsV = `repeat`(rhs.flat, N: lhs.shape.1, axis: 1)
            lhsV = lhs.flat
            resShape = lhs.shape
        }
    case (false, true):
        if lhs.shape.0 == 1 {
            lhsV = `repeat`(lhs.flat, N: rhs.shape.0, axis: 0)
            rhsV = rhs.flat
            resShape = rhs.shape
        } else {
            rhsV = `repeat`(rhs.flat, N: lhs.shape.0, axis: 0)
            lhsV = lhs.flat
            resShape = lhs.shape
        }
    case (false, false):
        if lhs.shape.0 == 1 {
            lhsV = `repeat`(lhs.flat, N: rhs.shape.0 * rhs.shape.1, axis: 0)
            rhsV = rhs.flat
            resShape = rhs.shape
        } else {
            rhsV = `repeat`(rhs.flat, N: lhs.shape.0 * lhs.shape.1, axis: 0)
            lhsV = lhs.flat
            resShape = lhs.shape
        }
    }
    
    return (lhsV, rhsV, resShape)
}

public func make_operator(_ lhs: matrix, operation: String, rhs: matrix)->matrix{
    let (lhsV, rhsV, resShape) = equalizeShapes(lhs, rhs: rhs)
    
    var result = zeros(resShape) // real result
    var resV:vector = zeros_like(lhsV) // flat vector
    if operation=="+" {resV = lhsV + rhsV}
    else if operation=="-" {resV = lhsV - rhsV}
    else if operation=="*" {resV = lhsV * rhsV}
    else if operation=="/" {resV = lhsV / rhsV}
    else if operation=="<" {resV = lhsV < rhsV}
    else if operation==">" {resV = lhsV > rhsV}
    else if operation==">=" {resV = lhsV >= rhsV}
    else if operation=="<=" {resV = lhsV <= rhsV}
    result.flat.grid = resV.grid
    return result
}
public func make_operator(_ lhs: matrix, operation: String, rhs: Double)->matrix{
    var result = zeros_like(lhs) // real result
//    var lhsM = asmatrix(lhs.grid) // flat
    let lhsM = lhs.flat
    var resM:vector = zeros_like(lhsM) // flat matrix
    if operation=="+" {resM = lhsM + rhs}
    else if operation=="-" {resM = lhsM - rhs}
    else if operation=="*" {resM = lhsM * rhs}
    else if operation=="/" {resM = lhsM / rhs}
    else if operation=="<" {resM = lhsM < rhs}
    else if operation==">" {resM = lhsM > rhs}
    else if operation==">=" {resM = lhsM >= rhs}
    else if operation=="<=" {resM = lhsM <= rhs}
    result.flat.grid = resM.grid
    return result
}
public func make_operator(_ lhs: Double, operation: String, rhs: matrix)->matrix{
    var result = zeros_like(rhs) // real result
//    var rhsM = asmatrix(rhs.grid) // flat
    let rhsM = rhs.flat
    var resM:vector = zeros_like(rhsM) // flat matrix
    if operation=="+" {resM = lhs + rhsM}
    else if operation=="-" {resM = lhs - rhsM}
    else if operation=="*" {resM = lhs * rhsM}
    else if operation=="/" {resM = lhs / rhsM}
    else if operation=="<" {resM = lhs < rhsM}
    else if operation==">" {resM = lhs > rhsM}
    else if operation==">=" {resM = lhs >= rhsM}
    else if operation=="<=" {resM = lhs <= rhsM}
    result.flat.grid = resM.grid
    return result
}

// DOUBLE ASSIGNMENT
public func <- (lhs:inout matrix, rhs:Double){
    let assign = ones((lhs.shape)) * rhs
    lhs = assign
}

// SOLVE
infix operator !/ : Multiplicative
public func !/ (lhs: matrix, rhs: vector) -> vector{
    return solve(lhs, b: rhs)}
// EQUALITY
public func ~== (lhs: matrix, rhs: matrix) -> Bool{
    return (rhs.flat ~== lhs.flat)}

//infix operator == : ComparisonPrecedence
public func == (lhs: matrix, rhs: matrix)->matrix{
    assert(lhs.count >= rhs.count, "Left matrix must be bigger than right.")
    let (lhsV, rhsV, shape) = equalizeShapes(lhs, rhs: rhs)
    return (lhsV == rhsV).reshape(shape)
}
infix operator !== : ComparisonPrecedence
public func !== (lhs: matrix, rhs: matrix)->matrix{
    assert(lhs.count >= rhs.count, "Left matrix must be bigger than right.")
    let (lhsV, rhsV, shape) = equalizeShapes(lhs, rhs: rhs)
    return (lhsV !== rhsV).reshape(shape)
}
public func == (lhs: matrix, rhs: Double)->matrix{
    return (lhs.flat == rhs).reshape(lhs.shape)
}
public func !== (lhs: matrix, rhs: Double)->matrix{
    return (lhs.flat !== rhs).reshape(lhs.shape)
}

/// ELEMENT WISE OPERATORS
// PLUS
//infix operator + : Additive
public func + (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "+", rhs: rhs)}
public func + (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "+", rhs: rhs)}
public func + (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, operation: "+", rhs: rhs)}
// MINUS
//infix operator - : Additive
public func - (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "-", rhs: rhs)}
public func - (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "-", rhs: rhs)}
public func - (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, operation: "-", rhs: rhs)}
// TIMES
//infix operator * : Multiplicative
public func * (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "*", rhs: rhs)}
public func * (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "*", rhs: rhs)}
public func * (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, operation: "*", rhs: rhs)}
// DIVIDE
//infix operator / : Multiplicative
public func / (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "/", rhs: rhs)
}
public func / (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "/", rhs: rhs)}
public func / (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, operation: "/", rhs: rhs)}
// LESS THAN
//infix operator < : ComparisonPrecedence
public func < (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, operation: "<", rhs: rhs)}
public func < (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "<", rhs: rhs)}
public func < (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "<", rhs: rhs)}
// GREATER THAN
//infix operator > : ComparisonPrecedence
public func > (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, operation: ">", rhs: rhs)}
public func > (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: ">", rhs: rhs)}
public func > (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: ">", rhs: rhs)}
// GREATER THAN OR EQUAL
//infix operator >= : ComparisonPrecedence
public func >= (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, operation: ">=", rhs: rhs)}
public func >= (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: ">=", rhs: rhs)}
public func >= (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: ">=", rhs: rhs)}
// LESS THAN OR EQUAL
//infix operator <= : ComparisonPrecedence
public func <= (lhs: matrix, rhs: Double) -> matrix{
    return make_operator(lhs, operation: "<=", rhs: rhs)}
public func <= (lhs: matrix, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "<=", rhs: rhs)}
public func <= (lhs: Double, rhs: matrix) -> matrix{
    return make_operator(lhs, operation: "<=", rhs: rhs)}
// BOOL
public func && (lhs: matrix, rhs: matrix) -> matrix{
    return (lhs.flat && rhs.flat).reshape(lhs.shape)
}
public func || (lhs: matrix, rhs: matrix) -> matrix{
    return (lhs.flat || rhs.flat).reshape(lhs.shape)
}
