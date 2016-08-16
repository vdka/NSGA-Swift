//
//  CrossoverTests.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 1/25/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

import XCTest

class CrossoverTests: XCTestCase {
	
	func testCrossover() {
		let a = 9.0
		let b = 11.0
		let (c, d) = a.crossover(with: b, eta: 20.0, lowerBound: 0.0, upperBound: 20.0)
		
		// Check that the crossover actually changes the value
		XCTAssert(a != c)
		XCTAssert(a != d)
		XCTAssert(b != c)
		XCTAssert(b != d)
		// compute the averages, and assert that they are the same before and after.
		XCTAssert([a, b].reduce(0.0, combine: +) / 2.0 == [c, d].reduce(0.0, combine: +) / 2.0)
	}

}
