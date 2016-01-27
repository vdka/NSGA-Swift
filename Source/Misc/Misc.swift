//
//  Misc.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 29/12/2015.
//  Copyright © 2015 Ethan Jackwitz. All rights reserved.
//

import Darwin

extension Array {
	subscript (safe index: Int) -> Generator.Element? {
		return indices ~= index ? self[index] : nil
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
