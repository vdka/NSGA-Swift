//
//  MutationTests.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 1/27/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

import XCTest

extension Double {
	/// Rounds the double to decimal places value
	func roundToPlaces(places:Int) -> Double {
		let divisor = 10.0 ** Double(places)
		return round(self * divisor) / divisor
	}
}

class MutationTests: XCTestCase {
	
	func testMutate() {
		let val = 10.0
		let mut = val.mutate(lowerBound: 0.0, upperBound: 20.0)
		
		// Check that the mutation actually changes the value
		XCTAssert(val != mut)
	}
	
	/**
	Test the polynomial mutation averages correctly
	*/
	func testAverage() {
		let n = 100_000
		let val = 10.0
		var total: Double = 0.0
		
		var buckets: [Int] = Array.init(count: 20, repeatedValue: 0)
		
		for _ in 0..<n {
			let mut = val.mutate(lowerBound: 0.0, upperBound: 20.0)
			
			switch Int(mut) {
			case (0...20):
				buckets[Int(mut)] += 1
			default: break
			}
			
			total += mut
		}
		
		let avg = total / Double(n)
		
		// Check that the output is parabolic
		XCTAssert(buckets[5..<10].follows(<=))
		XCTAssert(buckets[10..<15].follows(>=))
		
		// Check that the average of the output is roughly the starting value
		XCTAssert(avg.roundToPlaces(1) == val.roundToPlaces(1))
	}
	
}
