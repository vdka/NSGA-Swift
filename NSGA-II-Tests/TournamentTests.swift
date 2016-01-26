//
//  TournamentTests.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 1/26/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

import XCTest

class TournamentTests: XCTestCase {
	
	func testTournament() {
		
		let a = Point(x: 1, y: 1)
		let b = Point(x: 2, y: 2)
		
		XCTAssert(tournamentSelection(a, b) == a)
		
	}
	
}
