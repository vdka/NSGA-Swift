//
//  WaterEvaluatorWrapper.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 4/1/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

import Foundation
//import CWaterEvaluator

func evaluateWater(array: [String]) -> (exitCode: Int, netRev: Double, envCost: Double, feasViolation: Double) {
  
//  var a = 
  
  var a: [[CChar]] = array.map { str in
    return str.cStringUsingEncoding(NSUTF8StringEncoding)!
  }
  
  a = [[Int8()]] + a
  
  var (netRev, envCost, feasViolation): (Float, Int32, Float) = (0, 0, 0)
  
  
  var exitCode: Int32 = 0
  withExtendedLifetime(array) {
    var pointers = a.map({ UnsafeMutablePointer<Int8>($0) })
    exitCode = evaluateWaterC(Int32(a.count), &pointers, &netRev, &envCost, &feasViolation)
  }
  
  return (exitCode: Int(exitCode), netRev: Double(netRev), envCost: Double(envCost), feasViolation: Double(feasViolation))
}
