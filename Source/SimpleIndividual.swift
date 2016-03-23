//
//  SimpleIndividual.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 3/23/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

/// This is a simple individual which has only real values
struct SimpleIndividual: IndividualType, CustomStringConvertible {
	
	var reals: [F] = []
	var obj: [F] = []
	var hashValue: Int = hashArray.popLast()!
	
	init() {
		for i in 0..<Configuration.current.nReal {
			let r = F.random(Configuration.current.minReal[i], Configuration.current.maxReal[i])
			self.reals.append(r)
		}
	}
	
	init(reals: [F]) {
		guard reals.count == Configuration.current.nReal else { fatalError() }
		
		self.reals = reals
		
	}
	
	var description: String {
		var str = "(\(obj.first!.roundToPlaces(1))"
		for o in obj.dropFirst() {
			str = str + ", \(o.roundToPlaces(1))"
		}
		
		return str + ")"
	}
}
