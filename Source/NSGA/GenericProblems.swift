//
//  ProblemDescription.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 1/16/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

import Foundation

struct MOP1: ProblemType {
	typealias Individual = SimpleIndividual
	static func evaluate(individual: inout Individual) {
		let x = individual.reals.first!
		individual.obj.append(x ** 2)
		individual.obj.append((x - 2) ** 2)
	}

	static var config: Configuration {
		let c = Configuration(nReal: 1, nObj: 2,  minReal: [-10e5], maxReal: [10e5])
		return c
	}
}

import Darwin

struct ZDT4: ProblemType {
	typealias Individual = SimpleIndividual
	static func evaluate(individual: inout Individual) {
		let f1 = individual.reals.first!
		var g: F = 0.0
		for real in individual.reals.dropFirst() {
			g += real * real - 10.0 * cos(4.0 * F(M_PI) * real)
		}
		g += 91.0
		let h = 1.0 - sqrt(f1 / g)
		let f2 = g * h
		individual.reals[0] = f1
		individual.reals[1] = f2
	}

	static var config: Configuration {
		let c = Configuration(nReal: 2, nObj: 2, minReal: [0.0, 0.0], maxReal: [1.0, 1.0])
		return c
	}
}

