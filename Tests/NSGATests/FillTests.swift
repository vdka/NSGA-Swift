//
//  FillTests.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 1/19/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

import XCTest

struct Point: CrowdingAssignable {
	var x: Int
	var y: Int
	var obj: [Double]
	init(x: Int, y: Int) {
		self.x = x
		self.y = y
		self.obj = [Double(x), Double(y)]
	}
}

extension Point: Hashable {
	var hashValue: Int {
		return "\(x)\(y)".hashValue
	}
}

func == (lhs: Point, rhs: Point) -> Bool {
	return lhs.x == rhs.x && lhs.y == rhs.y
}

extension Point: Rankable {
	func dominates(other: Point) -> Bool? {
		var (flagOurs, flagTheirs) = (false, false)
		
		if self.x < other.x { flagOurs = true }
		if self.x > other.x { flagTheirs = true }
		if self.y < other.y { flagOurs = true }
		if self.y > other.y { flagTheirs = true }

		switch (flagOurs, flagTheirs) {
		case (true, false): return true
		case (false, true): return false
		default: return .None
		}
	}
}

class FillTests: XCTestCase {

	func testFill() {
		
		let points = [(1, 1), (0, 27), (27, 0), (20, 6), (14, 7), (10, 8), (9, 9), (8, 10), (7, 14), (6, 20), (13, 13)].map(Point.init)
		let expectedOutput = Set([(1, 1), (0, 27), (27, 0), (6, 20), (20, 6), (14, 7), (7, 14)].map(Point.init))
		
    let dominance = assignDominance(points)
    let fronts = assignFronts(dominance)
  	var output = Set(best(7, from: fronts))
		
		XCTAssert(output == expectedOutput)
		
		output = Set(best(points.count, from: fronts))
		
		XCTAssert(output == Set(points))
		
		let firstFronts = assignFronts(dominance)[0..<2]
		let ff = Set(firstFronts.flatten())
		output = Set(best(ff.count, from: fronts))
		
		XCTAssert(ff == output)
		
	}
	
}
