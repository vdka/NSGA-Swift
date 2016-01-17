//
//  Ranking.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 1/16/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

import Foundation

protocol Rankable: Hashable {
	/**
	- parameter other: The other `Rankable` to test dominance against

	- returns: true iff `self` dominates `other`
	*/
	func dominates(other: Self) -> Bool?
}

func assignRankings<U: Rankable>(individuals: [U]) -> [[U]] {
	var domination: [U: Int] = Dictionary.init(individuals.map({ ($0, 0) }))

	for individual in individuals {
		for otherIndividual in individuals
			where individual != otherIndividual && individual.dominates(otherIndividual) == true
		{
				domination[individual]! += 1
		}
	}

	return assignFronts(domination)
}

func assignFronts<U: Rankable>(individualsWithDominance: [U: Int]) -> [[U]] {
	var individualsWithDominance = individualsWithDominance

	var unAssigned = Set(individualsWithDominance.keys)

	var currentFront = 0

	var fronts: [[U]] = [[]]

	repeat {

		defer { currentFront += 1 }
		defer { fronts.append([]) }

		var nRemoved = 0
  	for individual in unAssigned
			where individualsWithDominance[individual] <= 0
		{
			fronts[currentFront].append(individual)
			unAssigned.remove(individual)
			nRemoved += 1
		}

  	for individual in unAssigned {
			individualsWithDominance[individual]! -= nRemoved
		}

	} while !unAssigned.isEmpty

	return Array(fronts.dropLast())
}
