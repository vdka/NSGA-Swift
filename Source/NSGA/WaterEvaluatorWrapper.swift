//
//  WaterEvaluatorWrapper.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 4/1/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

import Foundation
import CWaterEvaluator

/// Compute the prefix sum of `seq`.
public func scan<
    S : Sequence, U
    >(_ seq: S, _ initial: U, _ combine: (U, S.Iterator.Element) -> U) -> [U] {
    var result: [U] = []
    result.reserveCapacity(seq.underestimatedCount)
    var runningResult = initial
    for element in seq {
        runningResult = combine(runningResult, element)
        result.append(runningResult)
    }
    return result
}

public func withArrayOfCStrings<R>(
    _ args: [String], _ body: ([UnsafeMutablePointer<CChar>?]) -> R
    ) -> R {
    let argsCounts = Array(args.map { $0.utf8.count + 1 })
    let argsOffsets = [ 0 ] + scan(argsCounts, 0, +)
    let argsBufferSize = argsOffsets.last!

    var argsBuffer: [UInt8] = []
    argsBuffer.reserveCapacity(argsBufferSize)
    for arg in args {
        argsBuffer.append(contentsOf: arg.utf8)
        argsBuffer.append(0)
    }

    return argsBuffer.withUnsafeMutableBufferPointer { (argsBuffer) in
        let ptr = UnsafeMutableRawPointer(argsBuffer.baseAddress!).bindMemory(to: CChar.self, capacity: argsBuffer.count)
        var cStrings: [UnsafeMutablePointer<CChar>?] = argsOffsets.map { ptr + $0 }
        cStrings[cStrings.count - 1] = nil
        return body(cStrings)
    }
}

func evaluateWater(_ arguments: [String]) -> (exitCode: Int, netRev: Double, envCost: [Double], feasViolation: Double) {

//    var buffers: [UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>] = []
//
//    var argv: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?> = ([""] + arguments).withUnsafeBufferPointer {
//        let buffer = UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>.allocate(capacity: $0.count + 1)
//        buffer.initialize(from: $0.map { $0.withCString(strdup) })
//        buffer[$0.count] = nil
//        return buffer
//    }

    // TODO(vdka): Memory leak
//    defer {
//        argv.deallocate(capacity: arguments.count + 1)
//        for (index, arg) in arguments.enumerated() {
//            argv[index]?.deallocate(capacity: arg.utf8CString.count)
//        }
////        argv.deallocate(capacity: arguments.count + 1)
//    }
//
//    return withArrayOfCStrings(argsIncludingPath) { argv in
//        let retval = posix_spawn(&pid, path, nil, nil, argv, nil)
//        return (retval, pid)
//    }

    var (netRev, envCost, feasViolation): (Float, [Int32], Float) = (0, Array(repeatElement(0, count: 13)), 0)

    return withArrayOfCStrings([""] + arguments) { argv in
        var argv = argv

        var exitCode: Int32 = 0
        exitCode = evaluateWaterC(arguments.count + 1, &argv, &netRev, &envCost, &feasViolation)
        return (exitCode: Int(exitCode), netRev: Double(netRev), envCost: envCost.map(Double.init), feasViolation: Double(feasViolation))
    }
}
