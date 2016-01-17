//
//  NSGA_II_Tests.swift
//  NSGA-II-Tests
//
//  Created by Ethan Jackwitz on 1/17/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

enum Board: Int, Rankable {
	case TopLeft
	case TopCenter
	case TopRight

	case CenterLeft
	case Center
	case CenterRight

	case BottomLeft
	case BottomCenter
	case BottomRight

	var position: (x: Int, y: Int) {
		switch self {
		case .TopLeft: return (x: 0, y: 0)
		case .CenterLeft: return (x: 0, y: 1)
		case .BottomLeft: return (x: 0, y: 2)
		case .TopCenter: return (x: 1, y: 0)
		case .Center: return (x: 1, y: 1)
		case .BottomCenter: return (x: 1, y: 2)
		case .TopRight: return (x: 2, y: 0)
		case .CenterRight: return (x: 2, y: 1)
		case .BottomRight: return (x: 2, y: 2)
		}
	}

	func dominates(other: Board) -> Bool? {
		var (flagOurs, flagTheirs) = (false, false)
		let arr = [
			(self.position.x, other.position.x),
			(self.position.y, other.position.y),
		]
		arr.forEach { ours, theirs in
			//checks for higher values
			if ours < theirs {
				flagOurs = true
			}
			//checks for higher values
			if ours > theirs {
				flagTheirs = true
			}
		}

		switch (flagOurs, flagTheirs) {
		case (true, false): return true
		case (false, true): return false
		default: return .None
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
	
  func testRankingSystem() {
    let boardPositions = (0..<9).map({ x in Board(rawValue: x)! })

    let rankings = assignRankings(boardPositions)
  	
  	let expectedOutput: [[Board]] = [
    	[.BottomRight],
    	[.CenterRight, .BottomCenter],
    	[.TopRight, .Center, .BottomLeft],
    	[.CenterLeft, .TopCenter],
    	[.TopLeft]
  	]
  	
  	assert(rankings.flatMap({ return $0 }) == expectedOutput.flatMap({ return $0 }))
  }
	
}
