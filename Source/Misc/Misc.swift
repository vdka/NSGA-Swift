//
//  Misc.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 29/12/2015.
//  Copyright © 2015 Ethan Jackwitz. All rights reserved.
//

extension Array {
	subscript (index: UInt) -> Element {
		return self[Int(index)]
	}

	/**
	Randomly rearranges the elements of self using the Fisher-Yates shuffle
	*/
	mutating func shuffle () {

		for i in (0..<count) {
			let j = Int.random(0..<count)
			guard j != i else { continue }
			swap(&self[i], &self[j])
		}

	}

	/**
	Shuffles the values of the array into a new one

	:returns: Shuffled copy of self
	*/
	func shuffled () -> Array {
		var shuffled = self

		shuffled.shuffle()

		return shuffled
	}

	/**
	Applies cond to each element in array, splitting it each time cond returns a new value.
	
	- parameter cond: Function which takes an element and produces an equatable result.
	
	- returns: Array partitioned in order, splitting via results of cond.
	*/
	func partitionBy <T: Equatable> (cond: (Element) -> T) -> [Array] {
		var result = [Array]()
		var lastValue: T? = nil

		for item in self {
			let value = cond(item)

			if value == lastValue {
				let index: Int = result.count - 1
				result[index] += [item]
			} else {
				result.append([item])
				lastValue = value
			}
		}

		return result
	}

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
	return (0..<exponent-1).reduce(base) { total, _ in total * base }
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
