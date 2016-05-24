//
//  Ranking.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 1/16/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

//TODO (ethan): remove Hashable requirement
protocol Rankable: Hashable {
	/**
	- parameter other: The other `Rankable` to test dominance against

	- returns: true iff `self` dominates `other`
	*/
	func dominates(other: Self) -> Bool?
}

func assignDominance<U: Rankable>(individuals: [U]) -> [U: Int] {
  
  // This ends up being faster than working with an actual dictionary.
  var domination: [(U, Int)] = individuals.map({ ($0, 0) })

	for (i, individual) in individuals.enumerated() {
		for otherIndividual in individuals
			where individual.dominates(other: otherIndividual) == false && individual != otherIndividual
		{
      domination[i].1 += 1
		}
	}
  
  var dict = [U: Int](minimumCapacity: individuals.count)
  domination.forEach({ dict[$0.0] = $0.1 })

	return dict
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
