//
//  Mutation.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 1/26/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

extension Double {
	func clamp(lower: Double, upper: Double) -> Double {
		if self < lower { return lower }
		if self > upper { return upper }
		return self
	}
	
	/**
	Mutate a real number using polynomial distribution.
	
	- parameter eta:        A representing the inverse of the _power_ of mutation.
	- parameter lowerBound: The lower limit to mutate too.
	- parameter upperBound: The upper limit to mutate too.
	
	- returns: The mutated value.
	*/
	func mutate(eta: Double = 20.0, lowerBound: Double, upperBound: Double) -> Double {
		
		let delta1 = (self - lowerBound) / (upperBound - lowerBound)
		let delta2 = (upperBound - self) / (upperBound - lowerBound)
		let power = 1.0 / (eta + 1.0)
		let rnd = Double.random(0, 1)
		let deltaq: Double
		if Bool.random() {
			let xy = 1.0 - delta1
			let val = 2.0 * rnd + (1.0 - 2.0 * rnd) * (xy ** (eta + 1.0))
			deltaq = (val ** power) - 1.0
		} else {
			let xy = 1.0 - delta2
			let val = 2.0 * (1.0 - rnd) + 2.0 * (rnd - 0.5) * (xy ** (eta + 1.0))
			deltaq = 1.0 - (val ** power)
		}
		let ret = (self + deltaq * (upperBound - lowerBound)).clamp(lower: lowerBound, upper: upperBound)
		
		return ret
	}
}

extension Comparable {
  func clamp(lower: Self, upper: Self) -> Self {
    return min(max(self, lower), upper)
  }
}

extension Float {
	/**
	Mutate a real number using polynomial distribution.
	
	- parameter eta:        A representing the inverse of the _power_ of mutation.
	- parameter lowerBound: The lower limit to mutate too.
	- parameter upperBound: The upper limit to mutate too.
	
	- returns: The mutated value.
	*/
	func mutate(eta: Float = 20.0, lowerBound: Float, upperBound: Float) -> Float {
		
		let delta1 = (self - lowerBound) / (upperBound - lowerBound)
		let delta2 = (upperBound - self) / (upperBound - lowerBound)
		let power = 1.0 / (eta + 1.0)
		let rnd = Float.random(0, 1)
		let deltaq: Float
		if Bool.random() {
			let xy = 1.0 - delta1
			let val = 2.0 * rnd + (1.0 - 2.0 * rnd) * (xy ** (eta + 1.0))
			deltaq = (val ** power) - 1.0
		} else {
			let xy = 1.0 - delta2
			let val = 2.0 * (1.0 - rnd) + 2.0 * (rnd - 0.5) * (xy ** (eta + 1.0))
			deltaq = 1.0 - (val ** power)
		}
    let ret = (self + deltaq * (upperBound - lowerBound)).clamp(lower: lowerBound, upper: upperBound)
		
		return ret
	}
}
