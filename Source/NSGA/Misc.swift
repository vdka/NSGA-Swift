//
//  Misc.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 29/12/2015.
//  Copyright © 2015 Ethan Jackwitz. All rights reserved.
//

import Darwin

extension F {
	/// Rounds the double to decimal places value
	func roundTo(places:Int) -> F {
		let divisor = 10.0 ** F(places)
		return round(self * divisor) / divisor
	}
}

extension Array {
	subscript (safe index: Int) -> Iterator.Element? {
		return indices ~= index ? self[index] : nil
	}

	/**
	Randomly rearranges the elements of self using the Fisher-Yates shuffle
	*/
	mutating func shuffle() {
		
		for i in self.indices.dropFirst().reversed() {
			let j = Int.random(0, i, not: i)
			swap(&self[i], &self[j])
		}
		
	}
	
	/**
	Shuffles the values of the array into a new one
	
	:returns: Shuffled copy of self
	*/
	func shuffled() -> Array {
		var shuffled = self
		
		shuffled.shuffle()
		
		return shuffled
	}
	
	func repeated(_ n: Int) -> [Element] {
		guard self.count == 1 else { fatalError("Implementation limited to single element arrays") }
    return Array(repeatElement(first!, count: n))
	}
}

func transpose<T>(_ input: [[T]]) -> [[T]] {
	guard !input.isEmpty else { return [] }
	let count = input[0].count
	var out: [[T]] = Array(repeatElement([], count: count))
	for outer in input {
		for (index, inner) in outer.enumerated() {
			out[index].append(inner)
		}
	}

	return out
}

infix operator ** { associativity left precedence 155 }

func **(base: Int, exponent: Int) -> Int {
	return Int(pow(Double(base), Double(exponent)))
}

func **(base: Double, exponent: Double) -> Double {
	return pow(base, exponent)
}

func **(base: Float, exponent: Float) -> Float {
	return powf(base, exponent)
}

import Foundation

public func measure<T>(iterations: UInt = 1, forBlock block: () -> T) -> (time: Double, result: T) {
  precondition(iterations > 0, "Iterations must be a positive integer")
  
  var total : Double = 0
  var samples = [Double]()
  
  for _ in 0..<iterations{
    let start = NSDate.timeIntervalSinceReferenceDate()
    block()
    let took = Double(NSDate.timeIntervalSinceReferenceDate() - start)
    
    samples.append(took)
    
    total += took
  }
  
  let mean = total / Double(iterations)
  
  return (time: mean, result: block())
}
