//
//  helper-functions.swift
//  swix
//
//  Created by Scott Sievert on 8/9/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation

// Exploding/Concatenating

public func explode(_ x: matrix, axis: Int = 0) -> [vector] {
    var vecs: [vector] = []
    for i in 0..<(axis == 0 ? x.rows : x.columns) {
        let vec = axis == 0 ? x[i, 0..<x.columns] : x[0..<x.rows, i]
        vecs.append(vec)
    }
    return vecs
}

public func hexplode(_ x: matrix) -> [vector] {
    return explode(x, axis: 1)
}

public func vexplode(_ x: matrix) -> [vector] {
    return explode(x, axis: 0)
}

public func stack(_ vecs: [vector], axis: Int = 0) -> matrix {
    assert(vecs.allSatisfy { $0.count == vecs[0].count }, "Vectors must have equal length.")
    var mat = zeros((vecs.count, vecs[0].count))
    for (i, vec) in vecs.enumerated() {
        if axis == 0 {
            mat[i, 0..<mat.columns] = vec
        } else {
            mat[0..<mat.rows, i] = vec
        }
    }
    return mat
}

public func hstack(_ mats: [matrix]) -> matrix {
    assert(mats.allSatisfy { $0.rows == mats[0].rows }, "Matrices must have equal number of rows.")
    let resCols = mats.map { $0.columns }.reduce(0, +)
    var resMat = zeros((mats[0].rows, resCols))
    var colsImputed = 0
    for mat in mats {
        resMat[0..<resMat.rows, colsImputed..<(colsImputed + mat.columns)] = mat
        colsImputed += mat.columns
    }
    return resMat
}

public func vstack(_ mats: [matrix]) -> matrix {
    assert(mats.allSatisfy { $0.columns == mats[0].columns }, "Matrices must have equal number of columns.")
    let resRows = mats.map { $0.rows }.reduce(0, +)
    var resMat = zeros((resRows, mats[0].columns))
    var rowsImputed = 0
    for mat in mats {
        resMat[rowsImputed..<(rowsImputed + mat.rows), 0..<resMat.columns] = mat
        rowsImputed += mat.rows
    }
    return resMat
}

public func stack(_ mats: [matrix], axis: Int = 0) -> matrix {
    if axis == 0 {
        return vstack(mats)
    } else {
        return hstack(mats)
    }
}

public func hstack(_ vecs: [vector]) -> matrix {
    return stack(vecs, axis: 1)
}

public func vstack(_ vecs: [vector]) -> matrix {
    return stack(vecs, axis: 0)
}

// Argmax

public func argmax(_ x: matrix, axis: Int = 0) -> vector {
    let vecs = explode(x, axis: axis == 0 ? 1 : 0)
    let amVec = vector(vecs.map(argmax))
    return amVec
}

public func argmin(_ x: matrix, axis: Int = 0) -> vector {
    let vecs = explode(x, axis: axis == 0 ? 1 : 0)
    let amVec = vector(vecs.map(argmin))
    return amVec
}

// NORMs
public func norm(_ x:matrix, ord:String="assumed to be 'fro' for Frobenius")->Double{
    if ord == "fro" {return norm(x.flat, ord:2)}
    assert(false, "Norm type assumed to be \"fro\" for Forbenius norm!")
    return -1
}
public func norm(_ x:matrix, ord:Double=2)->Double{
    if      ord ==  inf {return max(sum(abs(x), axis:1))}
    else if ord == -inf {return min(sum(abs(x), axis:1))}
    else if ord ==  1   {return max(sum(abs(x), axis:0))}
    else if ord == -1   {return min(sum(abs(x), axis:0))}
    else if ord ==  2 {
        // compute only the largest singular value?
        let (_, s, _) = svd(x, compute_uv:false)
        return s[0]
    }
    else if ord == -2 {
        // compute only the smallest singular value?
        let (_, s, _) = svd(x, compute_uv:false)
        return s[-1]
    }
    
    assert(false, "Invalid norm for matrices")
    return -1
}

public func det(_ x:matrix)->Double{
    var result:CDouble = 0.0
    CVWrapper.det(!x, n:x.shape.0.cint, m:x.shape.1.cint, result:&result)
    return result
}

// basics
public func argwhere(_ idx: matrix) -> vector{
    return argwhere(idx.flat)
}
public func flipud(_ x:matrix)->matrix{
    let y = x.copy()
    CVWrapper.flip(!x, into:!y, how:"ud", m:x.shape.0.cint, n:x.shape.1.cint)
    return y
}
public func fliplr(_ x:matrix)->matrix{
    let y = x.copy()
    CVWrapper.flip(!x, into:!y, how:"lr", m:x.shape.0.cint, n:x.shape.1.cint)
    return y
}
public func rot90(_ x:matrix, k:Int=1)->matrix{
    // k is assumed to be less than or equal to 3
    let y = x.copy()
    if k == 1 {return fliplr(x).T}
    if k == 2 {return flipud(fliplr(y))}
    if k == 3 {return flipud(x).T}
    assert(false, "k is assumed to satisfy 1 <= k <= 3")
    return y
}

// modifying matrices, modifying equations
public func transpose (_ x: matrix) -> matrix{
    let m = x.shape.1
    let n = x.shape.0
    let y = zeros((m, n))
    vDSP_mtransD(!x, 1.stride, !y, 1.stride, m.length, n.length)
    return y
}
public func kron(_ A:matrix, B:matrix)->matrix{
    // an O(n^4) operation!
    func assign_kron_row(_ A:matrix, B:matrix,C:inout matrix, p:Int, m:Int, m_max:Int){
        var row = (m+0)*(p+0) + p-0
        row = m_max*m + 1*p
        
        let i = arange(B.shape.1 * A.shape.1)
        let n1 = arange(A.shape.1)
        let q1 = arange(B.shape.1)
        let (n, q) = meshgrid(n1, y: q1)
        C[row, i] = A[m, n.flat] * B[p, q.flat]
    }
    var C = zeros((A.shape.0*B.shape.0, A.shape.1*B.shape.1))
    for p in 0..<A.shape.1{
        for m in 0..<B.shape.1{
            assign_kron_row(A, B: B, C: &C, p: p, m: m, m_max: A.shape.1)
        }
    }
    
    return C
}

public func tril(_ x: matrix) -> vector{
    let (m, n) = x.shape
    let (mm, nn) = meshgrid(arange(m), y: arange(n))
    var i = mm - nn
    let j = (i < 0+S2_THRESHOLD)
    i[argwhere(j)] <- 0
    i[argwhere(1-j)] <- 1
    return argwhere(i)
}
public func triu(_ x: matrix)->vector{
    let (m, n) = x.shape
    let (mm, nn) = meshgrid(arange(m), y: arange(n))
    var i = mm - nn
    let j = (i > 0-S2_THRESHOLD)
    i[argwhere(j)] <- 0
    i[argwhere(1-j)] <- 1
    return argwhere(i)
}

// PRINTING
//public func println(_ x: matrix, prefix:String="matrix([", postfix:String="])", newline:String="\n", format:String="%.3f", printWholeMatrix:Bool=false){
//    print(prefix, terminator: "")
//    var pre:String
//    var post:String
//    var printedSpacer = false
//    for i in 0..<x.shape.0{
//        // pre and post nice -- internal variables
//        if i==0 {pre = ""}
//        else {pre = "        "}
//        if i==x.shape.0-1 {post=postfix}
//        else {post = "],"}
//
//        if printWholeMatrix || x.shape.0 < 16 || i<4-1 || i>x.shape.0-4{
//            print(x[i, 0..<x.shape.1], prefix:pre, postfix:post, format: format, printWholeMatrix:printWholeMatrix)
//        }
//        else if printedSpacer==false{
//            printedSpacer=true
//            Swift.print("        ...,")
//        }
//    }
//    print(newline, terminator: "")
//}
public func max(_ x: matrix) -> Double{
    return x.max()
}
public func min(_ x: matrix)->Double{
    return x.min()
}

public func max(_ x: matrix, axis: Int = 0) -> vector {
    return x.max(axis)
}
public func min(_ x: matrix, axis: Int = 0) -> vector {
    return x.min(axis)
}
//public func print(_ x: matrix, prefix:String="matrix([", postfix:String="])", newline:String="\n", format:String="%.3f", printWholeMatrix:Bool=false){
//    println(x, prefix:prefix, postfix:postfix, newline:"", format:format, printWholeMatrix:printWholeMatrix)
//}
