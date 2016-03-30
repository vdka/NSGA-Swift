//
//  main.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 29/12/2015.
//  Copyright © 2015 Ethan Jackwitz. All rights reserved.
//

import Foundation

public func measure(iterations: UInt = 1, forBlock block: () -> Void) -> Double {
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
	
	return mean
}

//let crops: [Double] = [10000.0].repeated(15)
//let months: [Double] = [2000.0].repeated(12)

let nsgaii = NSGAII<Water>()

let results = nsgaii.run(generations: 5, popSize: 16)

let validResults = results.filter({ $0.constraintViolation == 0 })

guard !validResults.isEmpty else {
	print("No valid results found!")
	exit(EXIT_FAILURE)
}

let resultString = validResults.reduce("", combine: { str, ind in [str, ind.stats, " ", ind.description, "\n"].joinWithSeparator("") } )
print(resultString)
