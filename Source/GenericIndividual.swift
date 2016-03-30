//
//  Individual.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 3/5/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

import Foundation

var hashArray: [Int] = []

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
}

func ==<I: IndividualType>(lhs: I, rhs: I) -> Bool {
	return lhs.hashValue == rhs.hashValue
}

