//
//  NSGA_II_Tests.swift
//  NSGA-II-Tests
//
//  Created by Ethan Jackwitz on 1/17/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

enum Board: Rankable {
	case TL, TR
	case BL, BR
	
	var position: (x: Int, y: Int) {
		switch self {
			case .BL: return (x: 0, y: 0)
			case .TL: return (x: 0, y: 1)
			case .BR: return (x: 1, y: 0)
			case .TR: return (x: 1, y: 1)
		}
	}
	
	func dominates(other: Board) -> Bool? {
	
		var (flagOurs, flagTheirs) = (false, false)
		let arr = [
			(self.position.x, other.position.x),
			(self.position.y, other.position.y)
		]
		
		for (ours, theirs) in arr {
			if ours < theirs { flagOurs = true }
			if theirs < ours { flagTheirs = true }
			if flagTheirs && flagOurs { return .None }
		}
		
		switch (flagOurs, flagTheirs) {
		case (true,  false): return true
		case (false, true):  return false
		case (false, false): return .None
		case (true,  true):  return .None
		}
		
	}
}

import XCTest

class RankingTests: XCTestCase {
    
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
	
	func testDominance() {
	
  	XCTAssert(Board.BL.dominates(.TR) == true)
  	XCTAssert(Board.BL.dominates(.BR) == true)
  	XCTAssert(Board.BL.dominates(.TL) == true)
  	
  	XCTAssert(Board.TR.dominates(.BL) == false)
  	XCTAssert(Board.BR.dominates(.BL) == false)
  	XCTAssert(Board.TL.dominates(.BL) == false)
  	
  	XCTAssert(Board.TL.dominates(.BR) == .None)
  	XCTAssert(Board.BR.dominates(.TL) == .None)
  	
  	XCTAssert(Board.TR.dominates(.BL) == false)
  	XCTAssert(Board.TR.dominates(.BR) == false)
  	XCTAssert(Board.TR.dominates(.TL) == false)
  		
  	XCTAssert(Board.TR.dominates(.TR) == .None)
  	XCTAssert(Board.BR.dominates(.BR) == .None)
  	XCTAssert(Board.TL.dominates(.TL) == .None)
  	XCTAssert(Board.BL.dominates(.BL) == .None)
		
	}
	
  func testRankingSystem() {
		let boardPositions: [Board] = [.TL, .TR, .BL, .BR]

		let output = assignDominance(boardPositions)
		
		let expectedOutput: [Board: Int] = [.BL: 0, .TL: 1, .BR: 1, .TR: 3]
  	
		XCTAssert(output == expectedOutput)
  }
	
	func testFrontAssignment() {
		let dominanceInput: [Board: Int] = [.BL: 0, .TL: 1, .BR: 1, .TR: 3]
		
		let output = assignFronts(dominanceInput)
		
  	let expectedOutput: [[Board]] = [
			[.BL],
			[.TL, .BR],
			[.TR]
  	]
		
  	XCTAssert(output.flatMap({ return $0 }) == expectedOutput.flatMap({ return $0 }))
	}
	
}
