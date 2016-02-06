//
//  NSGA-II.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 29/12/2015.
//  Copyright © 2015 Ethan Jackwitz. All rights reserved.
//

var hashArray: [Int] = Array(0..<100_000)

protocol IndividualType: Hashable, Rankable, CrowdingAssignable, Genetic {
	init()
	init(reals: [Double])
}

extension IndividualType {
  func dominates<I: IndividualType>(other: I) -> Bool? {
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


func ==<I: IndividualType>(lhs: I, rhs: I) -> Bool {
	return lhs.hashValue == rhs.hashValue
}

protocol ProblemType {
	static func evaluate(reals: [Double]?, bins: [Double]?) -> [Double]
	
	static var config: Configuration { get }
}

struct NSGAII<Individual: IndividualType, Problem: ProblemType> {
	
  typealias Population = [Individual]
	
	/**
	Creates offspring for a given population of _parents_.
	n offsping are created where n is the number of parents.
	
	- parameter parent: parent is the population of individuals with which we generate offspring.
	
	- returns: A population that represents the next _generation_ of Individuals
	*/
	func evolve(parent: Population) -> Population {
		guard parent.count % 4 == 0 else { fatalError("Sorry population sizes must be a multiple of 4") }
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
			population[i].obj = Problem.evaluate(population[i].reals, bins: .None)
		}
	}
	
	func run(generations nGenerations: Int = 20, popSize: Int = 20) -> Population {
		
		Configuration.current = Problem.config
		Configuration.current.popSize = popSize
		
		var population: Population = Population.init(count: Configuration.current.popSize, repeatedFunction: { return Individual() })
		
		evaluateAndUpdate(&population)
		
		for _ in (0..<nGenerations) {
			var offspring = evolve(population)
			
			evaluateAndUpdate(&offspring)
			
			population = best(Configuration.current.popSize, from: offspring + population)
			
			//DEBUG
			
			let dominance = assignDominance(population)
			let bestFront = assignFronts(dominance).first!
			
			print(bestFront)
    }

		return population
	}
	
}

struct Simple: IndividualType, CustomStringConvertible {
	var reals: [Double] = []
	var obj: [Double] = []
	var hashValue: Int = hashArray.popLast()!
	
	init() {
		for i in 0..<Configuration.current.nReal {
			let r = Double.random(Configuration.current.minReal[i], Configuration.current.maxReal[i])
			self.reals.append(r)
		}
	}
	
	init(reals: [Double]) {
		guard reals.count == Configuration.current.nReal else { fatalError() }
		self.reals = reals
	}
	
	var description: String {
		var str = "(\(obj.first!.roundToPlaces(2))"
		for o in obj.dropFirst() {
			str = str + ", \(o.roundToPlaces(2))"
		}
		
		return str + ")"
	}
}

import Darwin

extension Double {
	/// Rounds the double to decimal places value
	func roundToPlaces(places:Int) -> Double {
		let divisor = 10.0 ** Double(places)
		return round(self * divisor) / divisor
	}
}

