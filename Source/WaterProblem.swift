//
//  WaterModel.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 2/6/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

import Foundation

/**
Returns the standard output and exit status of running _command_ in a subshell.
The operator will block (by polling the current run loop) until _command_ exits.
@param command An absolute path to an executable, optionally followed by one or more arguments.
@return (output, exitStatus) The output and exit status of the executable invoked
by _command_.
*/
func bash(command: String) -> (output: String, exitStatus: Int) {
	let tokens = command.componentsSeparatedByString(" ")
	let launchPath = tokens[0]
	let arguments = tokens[1..<tokens.count].filter({ !$0.isEmpty })
	
	let task = NSTask()
	task.launchPath = launchPath
	task.arguments = Array(arguments)
	let stdout = NSPipe()
	task.standardOutput = stdout
	
	task.launch()
	task.waitUntilExit()
	
	let outData = stdout.fileHandleForReading.readDataToEndOfFile()
	let outStr = String(data: outData, encoding: NSUTF8StringEncoding)!
	return (outStr, Int(task.terminationStatus))
}

struct Water: ProblemType {
	
	struct ConstrainedIndividual: IndividualType {
		var reals: [F] = []
		var obj: [F] = []
		var constraintViolation: F = 0
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
		
		func dominates(other: ConstrainedIndividual) -> Bool? {
			
			switch (abs(self.constraintViolation), abs(other.constraintViolation)) {
			case (0, 0): break
			case (0, _): return true
			case (_, 0): return false
			case (let a, let b):
				guard a != b else { break }
				return a < b
			}
			
    	var (flagOurs, flagTheirs) = (false, false)
    	zip(zip(self.obj, other.obj), Configuration.current.optimizationDirection).forEach { pair, direction in
  			let (ours, theirs) = pair
  			
  			switch direction {
  			case .Minimize:
  				if ours < theirs { flagOurs = true }
  				if ours > theirs { flagTheirs = true }
  				
  			case .Maximize:
  				if ours > theirs { flagOurs = true }
  				if ours < theirs { flagTheirs = true }
  			}
    	}
    	
    	switch (flagOurs, flagTheirs) {
  		case (true, false): return true
  		case (false, true): return false
  		default: return .None
    	}
    }
	}
	
	typealias Individual = ConstrainedIndividual
	
	static let evaluatorBasePath = "/Users/Ethan/Downloads/evaluator_code/"
	static let evaluatorFile = evaluatorBasePath + "average.dat"
	static let nCrops = 15
	
	//	static let cropValues = [10000].repeated(15)
	//	static let cropValuesStr = String(cropValues.reduce("") {
	//		return $0 + $1.description + " "
	//	}.characters.dropLast())
	//
	//	static let tenvf = [100000].repeated(12)
	//	static let tenvfStr = String(tenvf.reduce("") {
	//		return $0 + $1.description + " "
	//	}.characters.dropLast())
	
	
	static func evaluate(inout individual: Individual) {
		
		let realsStr = String(individual.reals.reduce("") {
			return $0 + $1.description + " "
			}.characters.dropLast())
		
		let evalArgs = "\(evaluatorFile) \(nCrops) \(realsStr)"
		
		let (output, exitCode) = bash("\(evaluatorBasePath + "evaluator") \(evalArgs)")
		
		guard exitCode == 0 else { fatalError("evaluator returned with exit code \(exitCode)") }
		
		let tokens = output.characters.dropLast().split(" ").map(String.init)
		
		let netRevenue = F(tokens[0])!
		let flowDeficit = F(tokens[1])!
		let constraintViolation = F(tokens[2])!
		
		individual.obj = [netRevenue, flowDeficit]
		individual.constraintViolation = constraintViolation
		//		individual.constraintViolation =
		
		//		return [netRevenue, flowDeficit, feasable]
	}
	
	static var config: Configuration {
		
		let minCrops: [F] = [0.0].repeated(15)
		let minTenvf: [F] = [0.0].repeated(12)
		let maxCrops: [F] = [121808.0].repeated(15)
		let maxTenvf: [F] = [250000.0].repeated(12)
		
		let c = Configuration(nReal: 15 + 12, nObj: 2, minReal: minCrops + minTenvf, maxReal: maxCrops + maxTenvf, optimizationDirection: [.Maximize, .Minimize])
		return c
	}
}

extension Water.ConstrainedIndividual: CustomStringConvertible {
	var description: String {
//		return "profit: \(obj[0].roundToPlaces(1)), water deficit: \(obj[1].roundToPlaces(1)), constrViolation: \(constraintViolation.roundToPlaces(0))"
		return "\(obj[0].roundToPlaces(1)), \(obj[1].roundToPlaces(1))"
	}
}

extension Water.ConstrainedIndividual {
	var stats: String {
		return reals.reduce("", combine: { str, real in [str, real.roundToPlaces(1).description, ", "].joinWithSeparator("") })
	}
}
