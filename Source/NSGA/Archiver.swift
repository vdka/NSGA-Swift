//
//  Archiver.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 4/3/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

struct Archive<Problem: ProblemType> {

  typealias Individual = Problem.Individual

	var members: [Set<Individual>] = []

	mutating func insert(front: [Individual]) {
		members.append(Set(front))
		//TODO (ethan): print/log each insertion?
	}

  var finalFront: Set<Individual> {
    return members.last!
  }

  func formatIndividual(_ ind: Individual) -> [String] {
    let reals = ind.reals.map({ Int($0.roundTo(places: 0)).description })
    let objec = ind.obj.map({ Int($0.roundTo(places: 0)).description })

    return reals + objec
  }

	func toCSV() -> String {
    guard !members.isEmpty else {
			return "No valid results found"
    }

    let headings = Problem.columnNames.joined(separator: ", ")

    let body = finalFront.map { ind in
      return formatIndividual(ind).joined(separator: ", ")
    }.joined(separator: "\n")

    return [headings, body].joined(separator: "\n")
	}
}
