//
//  PerformanceTests.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 4/12/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

import XCTest

class PerformanceTests: XCTestCase {
  
  func testNSGAPerformance() {
    let nsgaii = NSGAII<MOP1>()

    measureBlock {
//      nsgaii.run(generations: 99, popSize: 20)
      nsgaii.run(generations: 1240, popSize: 16)
    }
  }
  
//  func testNSGAPerformanceP() {
//    let nsgaii = NSGAII<MOP1>()
//
//    measureBlock {
//      nsgaii.run(generations: 124, popSize: 16)
//    }
//  }
//  
  func testDominancePerformance() {
    measureBlock {
      assignDominance(testPoints)
    }
  }
  
  func testFrontAssignmentPerformance() {
    let dominance = assignDominance(testPoints)
    measureBlock {
      assignFronts(dominance)
    }
  }
}
