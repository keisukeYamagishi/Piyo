//
//  Utils.swift
//  OAuthSwift
//
//  Created by Dongri Jin on 1/28/15.
//  Copyright (c) 2015 Dongri Jin. All rights reserved.
//

import Foundation
// swiftlint:disable all

@inlinable
func rotateLeft(_ v: UInt16, n: UInt16) -> UInt16 {
    return ((v << n) & 0xFFFF) | (v >> (16 - n))
}

@inlinable
func rotateLeft(_ v: UInt32, n: UInt32) -> UInt32 {
    return ((v << n) & 0xFFFF_FFFF) | (v >> (32 - n))
}

@inlinable
func rotateLeft(_ x: UInt64, n: UInt64) -> UInt64 {
    return (x << n) | (x >> (64 - n))
}

infix operator +|

@inlinable
func +| <K, V>(left: [K: V], right: [K: V]) -> [K: V] {
    var map = [K: V]()
    for (k, v) in left {
        map[k] = v
    }
    for (k, v) in right {
        map[k] = v
    }
    return map
}

// If `rhs` is not `nil`, assign it to `lhs`.
infix operator ??=: AssignmentPrecedence // { associativity right precedence 90 assignment } // matches other assignment operators

/// If `rhs` is not `nil`, assign it to `lhs`.
@inlinable
func ??= <T>(lhs: inout T?, rhs: T?) {
    guard let rhs = rhs else { return }
    lhs = rhs
}

// swiftlint:enable all
