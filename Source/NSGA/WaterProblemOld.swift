//
//  WaterProblemOld.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 3/30/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

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
      .split(separator: "\n")
			.map(String.init)

		//Additionally tokenize each line by spaces.
		var tokens = byLines.map {
			$0.characters
        .split(separator: " ")
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
