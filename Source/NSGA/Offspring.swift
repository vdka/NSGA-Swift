//
//  Offspring.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 1/29/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

func generateOffspring<Individual: IndividualType>(parent a: Individual, parent b: Individual) -> (Individual, Individual) {
	
	let (mutationChance, crossoverChance, eta) = (Configuration.current.mutationChance, Configuration.current.crossoverChance, Configuration.current.eta)
	var (c1Reals, c2Reals): ([F], [F]) = ([], [])
	let performCrossover = Bool.random(probability: crossoverChance)
		
	for index in a.reals.indices {
		let (a, b) = (a.reals[index], b.reals[index])
		let (lower, upper) = (Configuration.current.minReal[index], Configuration.current.maxReal[index])
		
		let (c, d): (F, F)
		if performCrossover {
			(c, d) = a.crossover(with: b, eta: eta, lowerBound: lower, upperBound: upper)
		} else {
			(c, d) = (a, b)
		}
		
		switch (Bool.random(probability: mutationChance), Bool.random(probability: mutationChance)) {
		case (true, true):
			c1Reals.append(c.mutate(eta: eta, lowerBound: lower, upperBound: upper))
			c2Reals.append(d.mutate(eta: eta, lowerBound: lower, upperBound: upper))
		case (true, false):
			c1Reals.append(c.mutate(eta: eta, lowerBound: lower, upperBound: upper))
			c2Reals.append(d)
		case (false, true):
			c1Reals.append(c)
			c2Reals.append(d.mutate(eta: eta, lowerBound: lower, upperBound: upper))
		case (false, false):
			c1Reals.append(c)
			c2Reals.append(d)
		}
	}
	
	return (Individual(reals: c1Reals), Individual(reals: c2Reals))
}
