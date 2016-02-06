//
//  ProblemDescription.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 1/16/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

import Foundation

struct MOP1: ProblemType {
	static func evaluate(reals: [Double]?, bins: [Double]?) -> [Double] {
		let x = reals!.first!
		return [x ** 2, (x - 2) ** 2]
	}
	
	static var config: Configuration {
		let c = Configuration(nReal: 1, minReal: [-10e5], maxReal: [10e5])
		return c
	}
}

import Darwin

struct ZDT4: ProblemType {
	static func evaluate(reals: [Double]?, bins: [Double]?) -> [Double] {
		let f1 = reals!.first!
		var g = 0.0
		for real in reals!.dropFirst() {
			g += real * real - 10.0 * cos(4.0 * M_PI * real)
		}
		g += 91.0
		let h = 1.0 - sqrt(f1 / g)
		let f2 = g * h
		return [f1, f2]
	}
	
	static var config: Configuration {
		let c = Configuration(nReal: 2, minReal: [0.0, 0.0], maxReal: [1.0, 1.0])
		return c
	}
}
