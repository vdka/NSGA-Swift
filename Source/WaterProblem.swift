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
		
		print(["Profit": netRevenue, "Water Deficit": flowDeficit, "constraintViolation": constraintViolation])
		
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

let nMonths = 12

struct Crop {

  static let cropNames = [
  	"Rice", "Wheat", "Barley", "Maize", "Canola",
  	"Oats", "Soybeans", "Pasture", "Lucerne", "Vines",
  	"Veg", "Citrus", "Stone Fruit"
  ]


	/// The name of the crop
	let name: String
	/// How much each crop returns per hectare
	let grossMargin: Int
	/// Unsure
	let vcost: Int
	/// The water requirement per hectare for the crop
	let waterRequirements: [Float]
	/// The limit placed upon the crop for total area.
	let areaLimit: Int

	init(input: [String]) {
		var input = input
		self.name = input.first!
		input = Array(input.dropFirst())
		//first 12 things will be wreq
		self.grossMargin = Int(input.first!)!
		input = Array(input.dropFirst())
		self.vcost = Int(input.first!)!
		input = Array(input.dropFirst())
		self.waterRequirements = input[0..<nMonths].map({ Float($0)! })
		input = Array(input.dropFirst(nMonths))
		self.areaLimit = Int(input.first!)!
	}

}

struct Model {
	/// Cost of water per ML
	let waterCost: Int

	/// Temp
	let cp: Int

	/// The area available for crops
	let totalArea: Int

	/// Proportion of water taken from the ground (Unsure)
	let gwProportion: Float

	/// Ground water limit
	let gwLimit: Int

	/// The amount of water flowing into the irrigation area
	let inflow: [Int]

	/// The amount of water allocated to farm
	let allocation: [Float]

	/// Environmental flows, (Not sure what this means)
	let tenvf: [Int]

	/// The kinds of crops we may grow
	let crops: [Crop]

	init(fileContent content: String) {

		//Tokenize the file by line
		let byLines = content.characters
			.split("\n")
			.map(String.init)

		//Additionally tokenize each line by spaces.
		var tokens = byLines.map {
			$0.characters
				.split(" ")
				.map(String.init)
		}

		//First line, first token
		//let nCrops = Int(tokens.first!.first!)!

		//Line 2
		self.waterCost = Int(tokens[1][0])!
		self.cp = Int(tokens[1][1])!
		self.totalArea = Int(tokens[1][2])!

		//Line 3
		self.gwProportion = Float(tokens[2][0])!
		self.gwLimit = Int(tokens[2][1])!

		//Line 4
		self.inflow = Array(tokens[3].map({ Int($0)! }))

		//Drop the first 4 lines of tokens
		tokens = Array(tokens.dropFirst(4))

		//Initialize the crops
		self.crops = transpose([Crop.cropNames] + tokens[0..<nMonths + 2] + [tokens.last!]).map(Crop.init)

		//Drop all lines relevant to the crop type data.
		tokens = Array(tokens.dropFirst(nMonths + 2).dropLast())

		self.tenvf = tokens.first!.map({ Int($0)! })

		self.allocation = zip(inflow, tenvf).map({ Float($0.0 + $0.1) })

	}

}
