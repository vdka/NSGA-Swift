//
//  Configuration.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 1/30/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

struct Configuration {
	
	// singletonish patten
	static var current: Configuration!
	
	// default values
	var popSize: Int = 20
	var crossoverChance: Double = 0.9
	var mutationChance: Double = 0.1
	var eta: Double = 20
	
	// per problem values
	var nReal: Int
	var minReal: [Double]
	var maxReal: [Double]
	
	init(nReal: Int, minReal: [Double], maxReal: [Double]) {
		self.nReal = nReal
		self.minReal = minReal
		self.maxReal = maxReal
	}
}
