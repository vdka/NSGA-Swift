//
//  WaterEvaluatorWrapper.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 4/1/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

import Foundation
import CWaterEvaluator

func evaluateWater(_ arguments: [String]) -> (exitCode: Int, netRev: Double, envCost: Double, feasViolation: Double) {

  var argv: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?> = ([""] + arguments).withUnsafeBufferPointer {
      let buffer = UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>(allocatingCapacity: $0.count + 1)
      buffer.initializeFrom($0.map { $0.withCString(strdup) })
      buffer[$0.count] = nil
      return buffer
  }

  defer {
    for arg in argv..<argv + arguments.count {
      free(UnsafeMutablePointer<Void>(arg.pointee))
    }
    argv.deallocateCapacity(arguments.count + 1)
  }

  var (netRev, envCost, feasViolation): (Float, Int32, Float) = (0, 0, 0)

  var exitCode: Int32 = 0
  exitCode = evaluateWaterC(arguments.count + 1, argv, &netRev, &envCost, &feasViolation)

  return (exitCode: Int(exitCode), netRev: Double(netRev), envCost: Double(envCost), feasViolation: Double(feasViolation))
}
