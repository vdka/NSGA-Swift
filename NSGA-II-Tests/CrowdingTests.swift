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
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testFollows() {
		XCTAssert([0, 2, 4, 6].follows(<=))
		XCTAssertFalse([0, 2, 4, 6, 1].follows(<=))
		XCTAssert(["a", "b", "c", "d"].follows(<=))
		XCTAssert(["d", "d", "d", "d"].follows(<=))
		XCTAssertFalse(["d", "d", "d", "d"].follows(<))
	}
	
	func testCrowding() {
		
		let f: (Double) -> [Double] = {
			let x = Double($0)
			return [x, x * x]
		}
		
//		let population: [[Double]] = 0.0.stride(to: 10, by: 1).map(f).reverse()
		let population: [[Double]] = 0.0.stride(to: 10, by: 1).map(f)
		
		let dist = crowdingDistance(population)
//		let dist = crowdingDistance(population.map({ $0.shuffled() }))
		
		//NOTE (ethan): This is calculating the crowding distances but it they are not being associated with the correct indices.
		
		XCTAssert(dist.first! == Double.infinity)
		XCTAssert(dist.last! == Double.infinity)
		XCTAssert(dist.dropFirst().dropLast().follows(>=))
		
		
	}
	
}
