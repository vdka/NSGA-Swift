//
//  Individual.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 3/5/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

import Foundation

var _counter: Int = 0

var counter: Int {
  let c = _counter
  defer { _counter += 1 }
  return _counter
}

/**
`Rankable` requires `func dominates(other: Self) -> Bool?`
`CrowdingAssignable` provides `obj` or scores
`Genetic` provides `reals` or variables
*/
protocol IndividualType: Hashable, Rankable, CrowdingAssignable, Genetic, CustomStringConvertible {
	
	init()
	init(reals: [F])
	
}

extension IndividualType {
	var description: String {
    return [reals, obj].flatten().reduce("", combine: { str, d in str + d.roundTo(places: 1).description + "," })
	}
}

func ==<I: IndividualType>(lhs: I, rhs: I) -> Bool {
	return lhs.hashValue == rhs.hashValue
}
