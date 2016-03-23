//
//  ConstrainedIndivual.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 3/23/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

struct ConstrainedIndividual: IndividualType {
	var reals: [F] = []
	var obj: [F] = []
	var constraintViolation: F = 0
	var hashValue: Int = hashArray.popLast()!
	
	init() {
		for i in 0..<Configuration.current.nReal {
			let r = F.random(Configuration.current.minReal[i], Configuration.current.maxReal[i])
			self.reals.append(r)
		}
	}
	
	init(reals: [F]) {
		guard reals.count == Configuration.current.nReal else { fatalError() }
		
		self.reals = reals
		
	}
}

extension ConstrainedIndividual {
	
	func dominates(other: ConstrainedIndividual) -> Bool? {
		
		switch (abs(self.constraintViolation), abs(other.constraintViolation)) {
		case (0, 0): break
		case (0, _): return true
		case (_, 0): return false
		case (let a, let b):
			guard a != b else { break }
			return a < b
		}
		
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