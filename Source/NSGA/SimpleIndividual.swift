//
//  SimpleIndividual.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 3/23/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

/// This is a simple individual which has only real values
struct SimpleIndividual: IndividualType, CustomStringConvertible {
	
	var reals: [F] = []
	var obj: [F] = []
	var hashValue: Int = counter
	
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

extension SimpleIndividual {
	func dominates(other: SimpleIndividual) -> Bool? {
		var (flagOurs, flagTheirs) = (false, false)
		zip(zip(self.obj, other.obj), Configuration.current.optimizationDirection).forEach { pair, direction in
			let (ours, theirs) = pair
			
			switch direction {
			case .minimize:
				if ours < theirs { flagOurs = true }
				if ours > theirs { flagTheirs = true }
				
			case .maximize:
				if ours > theirs { flagOurs = true }
				if ours < theirs { flagTheirs = true }
			}
		}
		
		switch (flagOurs, flagTheirs) {
		case (true, false): return true
		case (false, true): return false
		default: return .none
		}
	}
}
