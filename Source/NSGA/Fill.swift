//
//  Fill.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 1/19/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

func best<U: protocol<Rankable, CrowdingAssignable>>(n: Int, from fronts: [[U]]) -> [U] {
	
	var results: [U] = []
	
	var nMembers = 0
	for front in fronts {
		guard nMembers != n else { return results }
		if nMembers + front.count <= n {
			results += front
			nMembers += front.count
		} else {
      
			//TODO (ethan): guage performance the map can be removed and append(ind.0) used. 1 less O(N) operation.
			//This computes crowding distance, then sorts by it.
			let sortedFront = zip(front, crowdingDistance(front: front))
        .sorted { $0.1.1 < $0.0.1 }
        .map { $0.0 } 
			
			for ind in sortedFront {
				results.append(ind)
				nMembers += 1
				guard results.count != n else { return results }
			}
		}
	}
	
	return results
}
