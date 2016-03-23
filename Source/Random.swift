//
//  SwiftRandom.swift
//
//  Created by Furkan Yilmaz on 7/10/15.
//  Copyright (c) 2015 Furkan Yilmaz. All rights reserved.
//

import Darwin

// each type has its own random

public extension Bool {
	/// SwiftRandom extension
	public static func random(probability: F = 0.5) -> Bool {
		return F.random(0, 1) <= probability
	}
}

public extension Int {
	/// SwiftRandom extension
	public static func random(range: Range<Int>) -> Int {
		return range.startIndex + Int(arc4random_uniform(UInt32(range.endIndex - range.startIndex)))
	}

	/// SwiftRandom extension
	public static func random(lower: Int = 0, _ upper: Int = 100, not: Int? = nil) -> Int {
		guard let not = not else {
  		return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
		}
		
  	let r = lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
		
		guard r != not else { return random(lower, upper, not: not) }
		
		return r
	}
}

public extension Double {
	/// SwiftRandom extension
	public static func random(lower: Double = 0, _ upper: Double = 100) -> Double {
		return (Double(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
	}
}

public extension Float {
	/// SwiftRandom extension
	public static func random(lower: Float = 0, _ upper: Float = 100) -> Float {
		return (Float(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
	}
}

public extension Array {
	/// SwiftRandom extension
	public func randomItem() -> Element {
		let index = Int(arc4random_uniform(UInt32(self.count)))
		return self[index]
	}

	public init(count: Int, repeatedFunction: () -> Element) {
		self = []
		for _ in (0..<count) {
			self.append(repeatedFunction())
		}
	}
}

public extension ArraySlice {
	/// SwiftRandom extension
	public func randomItem() -> Element {
		let index = Int.random(self.startIndex..<self.endIndex)
		return self[index]
	}
}

public struct Randoms {

	//==========================================================================================================
	// MARK: - Object randoms
	//==========================================================================================================

	public static func randomBool() -> Bool {
		return Bool.random()
	}

	public static func randomInt(range: Range<Int>) -> Int {
		return Int.random(range.startIndex, range.endIndex)
	}

	public static func randomInt(lower: Int = 0, _ upper: Int = 100) -> Int {
		return Int.random(lower, upper)
	}

	public static func randomPercentageisOver(percentage: Int) -> Bool {
		return Int.random() > percentage
	}

	public static func randomDouble(lower: Double = 0, _ upper: Double = 100) -> Double {
		return Double.random(lower, upper)
	}

	public static func randomFloat(lower: Float = 0, _ upper: Float = 100) -> Float {
		return Float.random(lower, upper)
	}

}

