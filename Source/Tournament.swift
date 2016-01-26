//
//  Generate.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 1/25/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

func tournamentSelection<U: Rankable>(a: U, _ b: U) -> U {
	
	switch a.dominates(b) {
	case true?:
		return a
	case false?:
		return b
	case .None:
		return [a, b].randomItem()
	}
	
}
