//
//  Individual.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 3/5/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

import Foundation

var hashArray: [Int] = Array(0..<100_000_000)

/**
`Rankable` requires `func dominates(other: Self) -> Bool?`
`CrowdingAssignable` provides `obj` or scores
`Genetic` provides `reals` or variables
*/
protocol IndividualType: Hashable, Rankable, CrowdingAssignable, Genetic {
	
	init()
	init(reals: [F])
	
}

extension IndividualType {
	func dominates<I: IndividualType>(other: I) -> Bool? {
  	var (flagOurs, flagTheirs) = (false, false)
  	zip(zip(self.obj, other.obj), Configuration.current.optimizationDirection).forEach { pair, direction in
			let (ours, theirs) = pair
			
			switch direction {
			case .Minimize:
    		if ours < theirs { flagOurs = true }
    		if ours > theirs { flagTheirs = true }
				
			case .Maximize:
    		if ours > theirs { flagOurs = true }
    		if ours < theirs { flagTheirs = true }
			}
  	}
  	
  	switch (flagOurs, flagTheirs) {
  	case (true, false): return true
  	case (false, true): return false
  	default: return .None
  	}
  }
}

func ==<I: IndividualType>(lhs: I, rhs: I) -> Bool {
	return lhs.hashValue == rhs.hashValue
}

