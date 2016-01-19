//
//  Crowding.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 1/17/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

//NOTE (ethan): this should be `{ get set }`
protocol CrowdingAssignable {
	var obj: [Double] { get }
}

/**
This function computes the _crowding distance_ for a set of coordinates

- parameter coordinates: An _n_ sized list of `Doubles` where _n_ is the number of dimensions in the coordinates

- returns: The crowding distance for each point
*/
//func crowdingDistance(inout front: [Individual]) {
func crowdingDistance(front: [CrowdingAssignable]) -> [Double] {
	
	let values = transpose(front.map({ $0.obj }))
	
	var crowding: [Double] = Array.init(count: front.count, repeatedValue: 0.0)

	for objValues in values {
		
		let sortedPairs = objValues.enumerate().sort({ $0.0.element < $0.1.element })
		
		let range = objValues.maxElement()! - objValues.minElement()!
		
		for (index, pair) in sortedPairs.enumerate() {
			guard let prev = objValues[safe: index - 1],
      			let next = objValues[safe: index + 1]
			else {
				crowding[pair.index] = Double.infinity
				continue
			}
			
			crowding[pair.index] += abs((next - prev) / range)
		}
		
	}
	
	for i in (0..<front.count) {
		crowding[i] = crowding[i] / Double(values.count)
	}
	
	return crowding
}
