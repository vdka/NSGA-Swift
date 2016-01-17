//
//  Evaluator.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 1/16/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

extension Individual {

	/**
	Tests the solution to the SCH1Problem
	*/
	mutating func testSCH1Problem() {
  	let obj1 = Double(Int(reals.first!) ** 2)
  	let obj2 = Double(Int(reals.first! - 2.0) ** 2)

  	obj = [obj1, obj2]


	}

	mutating func evaluate() {
		testSCH1Problem()

		//TODO (ethan): constraint handling
	}


}
