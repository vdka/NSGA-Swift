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
func crowdingDistance<U: CrowdingAssignable>(front: [U]) -> [Double] {

	let values = transpose(front.map({ $0.obj }))

	var crowding: [Double] = Array.init(count: front.count, repeatedValue: 0.0)

	for objValues in values {

		let sortedPairs = objValues.enumerate().sort({ $0.element < $1.element })

		let range = objValues.maxElement()! - objValues.minElement()!
		guard range != 0 else { fatalError() }

		for (index, pair) in sortedPairs.enumerate() {
			guard let prev = sortedPairs[safe: index - 1]?.element,
      			let next = sortedPairs[safe: index + 1]?.element
			else {
				crowding[pair.index] = Double.infinity
				continue
			}
			
			let c = abs((next - prev) / range)

			crowding[pair.index] += c
		}

	}

	for index in front.indices {
		crowding[index] = crowding[index] / Double(values.count)
	}

	return crowding
}
