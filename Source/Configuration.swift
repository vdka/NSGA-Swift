//
//  Configuration.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 1/30/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

enum Direction { case Minimize, Maximize }

public typealias F = Double

struct Configuration {

	// singletonish patten
	static var current: Configuration!
	
	// default values
	var popSize: Int = 20
	var crossoverChance: F = 0.9
	var mutationChance: F = 0.1
	var eta: F = 20
	
	// per problem values
	var nReal: Int
	var nObj: Int
	var minReal: [F]
	var maxReal: [F]
	var optimizationDirection: [Direction]
	
	init(nReal: Int, nObj: Int, minReal: [F], maxReal: [F], optimizationDirection: [Direction]? = nil) {
		self.nReal = nReal
		self.minReal = minReal
		self.maxReal = maxReal
		self.nObj = nObj
		
		if let optimizationDirection = optimizationDirection {
			self.optimizationDirection = optimizationDirection
		} else {
			self.optimizationDirection = Array<Direction>(count: nObj, repeatedValue: .Minimize)
		}
	}
}
