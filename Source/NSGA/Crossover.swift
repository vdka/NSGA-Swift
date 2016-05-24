//
//  Crossover.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 1/26/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

protocol Genetic {
	var reals: [F] { get set }
}

extension F {
	/**
	Simulated binary crossover for two real numbers, output will have the same average, provided the
	values generated lay within the bounds.
	
	- parameter other:      The other Real number
	- parameter eta:        A value representing the inverse of the _power_ of crossover.
	- parameter lowerBound: The lower limit for generated values
	- parameter upperBound: The upper limit for generated values
	
	- returns: Returns the crossed over values.
	*/
	func crossover(with other: F, eta: F, lowerBound: F, upperBound: F) -> (F, F) {
		guard abs(self - other) > 0 else { return (self, other) }
		
		let y1 = min(self, other)
		let y2 = max(self, other)
		
    let rand = F.random(0, 1)
		
		var beta = 1.0 + (2.0 * (y1 - lowerBound) / (y2 - y1))
		var alpha = 2.0 - (beta ** -(eta + 1.0))
		
		var betaq: F
		if rand <= (1.0 / alpha) {
			betaq = (rand * alpha) ** (1.0 / (eta + 1.0))
		} else {
			betaq = (1.0 / (2.0 - rand * alpha)) ** (1.0 / (eta + 1.0))
		}
		
		let c1 = (0.5 * ((y1 + y2) - betaq * (y2 - y1))).clamp(lower: lowerBound, upper: upperBound)
		beta = 1.0 + (2.0 * (upperBound - y2) / (y2 - y1))
		alpha = 2.0 - (beta ** -(eta + 1.0))
		
		if rand <= (1.0 / alpha) {
			betaq = (rand * alpha) ** (1.0 / (eta + 1.0))
		} else {
			betaq = (1.0 / (2.0 - rand * alpha)) ** (1.0 / (eta + 1.0))
		}
		
		let c2 = (0.5 * ((y1 + y2) + betaq * (y2 - y1))).clamp(lower: lowerBound, upper: upperBound)
		
		return (c1, c2)
		
	}
}
