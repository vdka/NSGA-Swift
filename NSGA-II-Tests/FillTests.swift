//
//  FillTests.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 1/19/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

import XCTest

struct Point {
	var x: UInt8
	var y: UInt8
}

extension Point: Hashable {
	var hashValue: Int {
		return Int("\(x)\(y)")!
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

extension Point: CrowdingAssignable {
	var obj: [Double] {
		return [Double(x), Double(y)]
	}
}

class FillTests: XCTestCase {

	func testFill() {
		
		let points = [(1, 1), (0, 27), (27, 0), (20, 6), (14, 7), (10, 8), (9, 9), (8, 10), (7, 14), (6, 20), (13, 13)].map(Point.init)
		let expectedOutput = Set([(1, 1), (0, 27), (27, 0), (6, 20), (20, 6), (14, 7), (7, 14)].map(Point.init))
		
  	var output = Set(best(7, from: points))
		
		XCTAssert(output == expectedOutput)
		
		output = Set(best(points.count, from: points))
		
		XCTAssert(output == Set(points))
		
		let dominance = assignDominance(points)
		let firstFronts = assignFronts(dominance)[0..<2]
		let ff = Set(firstFronts.flatten())
		output = Set(best(ff.count, from: points))
		
		XCTAssert(ff == output)
		
	}
	
}
