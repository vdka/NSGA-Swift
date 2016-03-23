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
	func roundToPlaces(places:Int) -> F {
		let divisor = 10.0 ** F(places)
		return round(self * divisor) / divisor
	}
}

extension Array {
	subscript (safe index: Int) -> Generator.Element? {
		return indices ~= index ? self[index] : nil
	}

	/**
	Randomly rearranges the elements of self using the Fisher-Yates shuffle
	*/
	mutating func shuffle() {
		
		for i in self.indices.dropFirst().reverse() {
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
	
	func repeated(n: UInt) -> [Element] {
		guard self.count == 1 else { fatalError("Implementation limited to single element arrays") }
		return Array.init(count: Int(n), repeatedValue: first!)
	}
}

func transpose<T>(input: [[T]]) -> [[T]] {
	guard !input.isEmpty else { return [] }
	let count = input[0].count
	var out: [[T]] = Array.init(count: count, repeatedValue: [])
	for outer in input {
		for (index, inner) in outer.enumerate() {
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

extension Dictionary {

	init<S: SequenceType
		where S.Generator.Element == Element>
		(_ seq: S)
	{
		self.init()
		var gen = seq.generate()
		while let (k, v) = gen.next() {
			self[k] = v
		}
  }
}
