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
			let input = ([1, 2, 3, 4], [5, 6, 7, 8])
			var r = crossoverReals(1.0, parentsReals: input)
			
			XCTAssert(Set(r.0 + r.1) == Set(input.0 + input.1))
			XCTAssert(r.0 != input.0)
			XCTAssert(r.1 != input.1)
			
			r = crossoverReals(0.0, parentsReals: input)
			
			XCTAssert(r.0 == input.0)
			XCTAssert(r.1 == input.1)
    }
	
}
