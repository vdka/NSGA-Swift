//
//  NSGA-II.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 29/12/2015.
//  Copyright © 2015 Ethan Jackwitz. All rights reserved.
//

//enum ConfigurationError: ErrorType {
//	case
//}

var hashArray: [Int] = (0..<Int.max).reverse()

struct Configuration {
	let nObjectives: Int
	let nConstraints: Int

	let nReal: Int
	let nBinary: Int

	///Min value of real[i]
	let minReal: [Double]
	///Max value of real[i]
	let maxReal: [Double]

	///Number of bits for binary[i]
	let nBits: [Int]

	///Min value of binary[i]
	let minBinary: [Double]
	///Max value of binary[i]
	let maxBinary: [Double]

	let realCrossoverChance: Double
	let realMutationChance: Double

	let binaryCrossOverChance: Double
	let binaryMutationChance: Double
}

enum GenerationMethod {
	case Random
	case Offspring(Individual, Individual)
}

struct Individual: Equatable, Hashable {
	let hashValue: Int = hashArray.popLast()!
	var rank: Int
	var constraintViolation: Double
	/// The variables representable as real numbers
	var reals: [Double]
	var minReal: [Double]
	var maxReal: [Double]
	/// The variables representable as binary numbers (genes)
	var genes: [[Bool]]
	var binary: [Double]
	var minBinary: [Double]
	var maxBinary: [Double]
	var obj: [Double]
	var constraint: [Double]
	var crowdingDistance: Double

	init(config: Configuration) {
		self.reals = []
		self.binary = []
		self.minBinary = config.minBinary
		self.maxBinary = config.maxBinary
		self.minReal = config.minReal
		self.maxReal = config.maxReal
		self.genes = [[]]
		self.rank = 0
		self.constraintViolation = 0.0
		self.obj = []
		self.constraint = []
		self.crowdingDistance = 0.0
	}

	static func random(config: Configuration) -> Individual {
		let reals = (0..<config.nReal)
			.map({ _ in Double.random() })

		let genes = (0..<config.nBinary)
			.map({
				(0..<config.nBits[$0]).map({ _ in Bool.random() })
			})

		var randomIndividual = Individual(config: config)
		randomIndividual.reals = reals
		randomIndividual.genes = genes

		return randomIndividual
	}

	mutating func decode() {
		if genes.count != 0 {
			for (geneIndex, gene) in genes.enumerate() {
				var sum: Int = 0
				for (index, val) in gene.enumerate() where val == true {
					sum += 2 ** (gene.count - 1 - index)
				}

				binary[geneIndex] = minBinary[geneIndex]
					+ Double(sum) * (maxBinary[geneIndex] - minBinary[geneIndex])
					/ Double(2 ** (gene.count - 1))
			}
		}
	}
}

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

func == (lhs: Individual, rhs: Individual) -> Bool {
	return lhs.hashValue == rhs.hashValue
}

struct Population {
	var individuals: [Individual] = []

	let size: Int

	init(size: Int, individualConfig: Configuration, random: Bool = false) {
		self.size = size
		if random {
			individuals = (0..<size)
				.map({ _ in Individual.random(individualConfig) })
		}
	}

}
