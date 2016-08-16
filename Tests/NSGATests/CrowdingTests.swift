//
//  CrowdingTests.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 1/17/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

import XCTest

extension CollectionType where SubSequence.Generator.Element == Generator.Element {
	func follows(comparison: (Generator.Element, Generator.Element) -> Bool) -> Bool {

		switch self.count {
		case 0: return true
		case 1: return true
		default: break
		}

		var last: Generator.Element = self.first!

		for curr in self.dropFirst() {
			guard comparison(last, curr) else {
				return false
			}

			last = curr
		}

		return true
	}
}

class CrowdingTests: XCTestCase {

	func testFollows() {
		XCTAssert([0, 2, 4, 6].follows(<=))
		XCTAssertFalse([0, 2, 4, 6, 1].follows(<=))
		XCTAssert(["a", "b", "c", "d"].follows(<=))
		XCTAssert(["d", "d", "d", "d"].follows(<=))
		XCTAssertFalse(["d", "d", "d", "d"].follows(<))
	}
	
	func testCrowding() {

		let f: (Int) -> Point = {
			let x = Int($0)
			return Point(x: x, y: x * x)
		}
		
		let population = 0.stride(through: 15, by: 1).map({ f($0) })
		
		let dist = crowdingDistance(population)

		XCTAssert(dist.first! == Double.infinity)
		XCTAssert(dist.last! == Double.infinity)
		XCTAssert(dist.dropFirst().dropLast().follows(<=))
		
		let points = [(20, 6), (14, 7), (10, 8), (9, 9), (8, 10), (7, 14), (6, 20)].map({ Point(x: $0.0, y: $0.1) })
		
		let dist2 = crowdingDistance(points)
		
		XCTAssert(dist2.first == Double.infinity)
		XCTAssert(dist2.last == Double.infinity)
		
		XCTAssert(dist2[3] == dist2.minElement())
		XCTAssert(dist2[2] == dist2[4])
		XCTAssert(dist2[1] == dist2[5])

	}

}
