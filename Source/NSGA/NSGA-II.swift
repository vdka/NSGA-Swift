
protocol ProblemType {

	associatedtype Individual: IndividualType

	static func evaluate(individual: inout Individual)

	static var config: Configuration { get }

  static var columnNames: [String] { get }
}

extension ProblemType {
  static var columnNames: [String] { return [] }
}

class NSGAII<Problem: ProblemType> {

	init() {
		Configuration.current = Problem.config
	}

  typealias Population = [Problem.Individual]

	var archive = Archive<Problem>()

	/**
	Creates offspring for a given population of _parents_.
	n offsping are created where n is the number of parents.

	- parameter parentPopulation: parent is the population of individuals with which we generate offspring.

	- returns: A population that represents the next _generation_ of Individuals
	*/
	func evolve(parentPopulation: Population) -> Population {
		let orderA = Array(parentPopulation.indices).shuffled().map({ parentPopulation[$0] })
		let orderB = Array(parentPopulation.indices).shuffled().map({ parentPopulation[$0] })

		var offspring: Population = []
		offspring.reserveCapacity(parentPopulation.count)

    for i in stride(from: 0, to: parentPopulation.endIndex, by: 4) {

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

	func evaluateAndUpdate(population: inout Population) {

		for i in population.indices {
			Problem.evaluate(individual: &population[i])
		}
	}

	func run(generations nGenerations: Int = 20, popSize: Int = 20) -> Population {
		guard popSize % 4 == 0 else { fatalError("Population sizes must be a multiple of 4") }

		Configuration.current.popSize = popSize

		var population = Population(count: Configuration.current.popSize, repeatedFunction: Problem.Individual.init)

    evaluateAndUpdate(population: &population)

		for _ in (0..<nGenerations) {
      var offspring = evolve(parentPopulation: population)

			evaluateAndUpdate(population: &offspring)

    	let dominance = assignDominance(individuals: population + offspring)
    	let fronts = assignFronts(individualsWithDominance: dominance)

      // TODO: resolve issues surrounding this first.
//			archive.insert(front: fronts.first!)

			population = best(n: Configuration.current.popSize, from: fronts)
    }

  	let dominance = assignDominance(individuals: population)
  	let fronts = assignFronts(individualsWithDominance: dominance)
		archive.insert(front: fronts.first!)

		return population
	}

}
