//
//  File.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 1/19/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

func best<U: protocol<Rankable, CrowdingAssignable>>(n: Int, from individuals: [U]) -> [U] {
	guard n < individuals.count else { return individuals }
	
	let dominance = assignDominance(individuals)
	let fronts = assignFronts(dominance)
	
	var results: [U] = []
	
	var nMembers = 0
	for front in fronts {
		guard nMembers != n else { return results }
		if nMembers + front.count <= n {
			results += front
			nMembers += front.count
		} else {
			
			let sortedFront = zip(front, crowdingDistance(front)).sort({ $0.1.1 < $0.0.1 }).map({ $0.0 })
			
			for ind in sortedFront {
				results.append(ind)
				nMembers += 1
				guard results.count != n else { return results }
			}
		}
	}
	
	return results
}
