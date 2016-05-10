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
	
	mutating func insert(front front: [Individual]) {
		members.append(Set(front))
		//TODO (ethan): print/log each insertion?
	}
  
  var finalFront: Set<Individual> {
    return members.last!
  }
  
  func formatIndividual(ind: Individual) -> [String] {
    let reals = ind.reals.map({ Int($0.roundToPlaces(0)).description })
    let objec = ind.obj.map({ Int($0.roundToPlaces(0)).description })
    
    return reals + objec
  }
  
	func toCSV() -> String {
    guard !members.isEmpty else {
			return "No valid results found"
    }
    
    let headings = Problem.columnNames.joinWithSeparator(", ")

    let body = finalFront.map { ind in
      return formatIndividual(ind).joinWithSeparator(", ")
    }.joinWithSeparator("\n")
    
    return [headings, body].joinWithSeparator("\n")
	}
}
