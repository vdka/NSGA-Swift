//
//  Dominance.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 1/16/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

import Foundation

extension Individual: Rankable {
	func dominates(other: Individual) -> Bool? {
		var (flagOurs, flagTheirs) = (false, false)
		zip(self.obj, other.obj).forEach { ours, theirs in
			if ours < theirs { flagOurs = true }
			if ours > theirs { flagTheirs = true }
		}

		switch (flagOurs, flagTheirs) {
		case (true, false): return true
		case (false, true): return false
		default: return .None
		}
	}
}
