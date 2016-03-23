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


extension ConstrainedIndividual: CustomStringConvertible {
	var description: String {
		return "profit: \(obj[0].roundToPlaces(1)), water deficit:\(obj[1].roundToPlaces(1)), constrViolation: \(constraintViolation.roundToPlaces(0))"
	}
}

let crops: [Double] = [10000.0].repeated(15)
let months: [Double] = [2000.0].repeated(12)

//Water.evaluate(crops + months, bins: nil)
//print(Water.evaluate([], bins: nil))

let nsgaii = NSGAII<Water>()

//print(measure {
  print(nsgaii.run(generations: 10, popSize: 16))
//})
