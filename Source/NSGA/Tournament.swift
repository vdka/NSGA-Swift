//
//  Generate.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 1/25/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

func tournamentSelection<U: Rankable>(_ a: U, _ b: U) -> U {
	
	switch a.dominates(other: b) {
	case true?:
		return a
	case false?:
		return b
	case .none:
		return [a, b].randomItem()
	}
	
}
