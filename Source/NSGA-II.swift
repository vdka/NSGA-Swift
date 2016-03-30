//
//  NSGA-II.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 29/12/2015.
//  Copyright © 2015 Ethan Jackwitz. All rights reserved.
//

protocol ProblemType {
	
	associatedtype Individual: IndividualType
	
	static func evaluate(inout individual: Individual)
	
	static var config: Configuration { get }
}

struct NSGAII<Problem: ProblemType> {
	
	init() {
		Configuration.current = Problem.config
	}
	
  typealias Population = [Problem.Individual]
	
	/**
	Creates offspring for a given population of _parents_.
	n offsping are created where n is the number of parents.
	
	- parameter parent: parent is the population of individuals with which we generate offspring.
	
	- returns: A population that represents the next _generation_ of Individuals
	*/
	func evolve(parent: Population) -> Population {
		let orderA = Array(parent.indices).shuffled().map({ parent[$0] })
		let orderB = Array(parent.indices).shuffled().map({ parent[$0] })
		
		var offspring: Population = []
		offspring.reserveCapacity(parent.count)
		
		for i in 0.stride(to: parent.endIndex, by: 4) {
			
			let parent1 = tournamentSelection(orderA[i], orderA[i + 1])
  		let parent2 = tournamentSelection(orderA[i + 2], orderA[i + 3])
			let (child1, child2) = generateOffspring(parent: parent1, parent: parent2)
			
			let parent3 = tournamentSelection(orderB[i], orderB[i + 1])
  		let parent4 = tournamentSelection(orderB[i + 2], orderB[i + 3])
			let (child3, child4) = generateOffspring(parent: parent3, parent: parent4)
			
			offspring += [child1, child2, child3, child4]
		}
		
		return offspring
	}
	
	func evaluateAndUpdate(inout population: Population) {
		
		for i in population.indices {
			Problem.evaluate(&population[i])
		}
	}
	
	func run(generations nGenerations: Int = 20, popSize: Int = 20) -> Population {
		guard popSize % 4 == 0 else { fatalError("Sorry population sizes must be a multiple of 4") }
		
		hashArray = Array(0..<nGenerations * popSize + popSize)
		
		Configuration.current = Problem.config
		Configuration.current.popSize = popSize
		
		var population: Population = Population.init(count: Configuration.current.popSize, repeatedFunction: { return Problem.Individual() })
		
		evaluateAndUpdate(&population)
		
		for i in (0..<nGenerations) {
			var offspring = evolve(population)
			
			evaluateAndUpdate(&offspring)
			
			population = best(Configuration.current.popSize, from: population + offspring)
			
//			population = offspring + population
			
//    	let dominance = assignDominance(population)
//    	let fronts = assignFronts(dominance)
			
			print("End of generation \(i)")
			
			#if DEBUG
			
  			let dominance = assignDominance(population)
  			let bestFront = assignFronts(dominance).first!
				
				print(bestFront.reduce("", combine: { str, ind in str + (ind as! Water.ConstrainedIndividual).description + "\n" } ))
			
			#endif
    }

		return population
	}
	
}
