//
//  WaterModel.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 2/6/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

var bestNetRevenue: F = -F.infinity {
  didSet {
//  	print("New best net revenue: \(bestNetRevenue)")
  }
}

var bestFlowDeficit: F = F.infinity {
  didSet {
//  	print("New best flow deficit: \(bestFlowDeficit)")
  }
}

struct Water: ProblemType {
  
  static var columnNames: [String] = {
		 let crops = ["Rice", "Wheat", "Barley", "Maize", "Canola", "Oats", "Soybean", "W_pasture", "S_pasture", "Lucerne", "Vines", "W_veg", "S_veg", "Citrus", "Stone_fruit"]
		let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    return crops + months + ["Profit", "Flow Deficit"]
  }()
	
	struct ConstrainedIndividual: IndividualType {
		var reals: [F] = []
		var obj: [F] = []
		var constraintViolation: F = 0
		var hashValue: Int = counter
		
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
	
	static let nCrops = 15
  
  static func argsFor(individual: Individual) -> [String] {
    let realStrings = individual.reals.map { i -> String in
//      guard i >= 100 else { return "0" } // clamp values < 100 to 0 WILL SKEW RESULTS
      return Int(i.roundToPlaces(0)).description
    }
		
    let args: [String] = [evaluatorFile, nCrops.description] + realStrings
    
    return args
  }
  
	static func evaluate(inout individual: Individual) {
    
    let args = argsFor(individual)
    
    let r = evaluateWater(args)
    
		let (exitCode, netRevenue, flowDeficit, constraintViolation) = r
		
		guard exitCode == 0 else { fatalError("evaluator returned with exit code \(exitCode)") }
		
		individual.obj = [netRevenue, flowDeficit.clamp(min: 0, max: Double.infinity)]
		individual.constraintViolation = constraintViolation.clamp(min: 0, max: F.infinity)
		
		guard !netRevenue.isSignMinus && constraintViolation == 0 else { return }
		
		if flowDeficit < bestFlowDeficit {
			bestFlowDeficit = flowDeficit
		}
		
		if netRevenue > bestNetRevenue {
			bestNetRevenue = netRevenue
		}
	}
	
	static var config: Configuration {
		
		let minTenvf: [F] = [0.0].repeated(12)
		let maxTenvf: [F] = [250000.0].repeated(12)
		let minCrops: [F] = [0.0].repeated(15)
		let maxCrops: [F] = [121808.0].repeated(15)
		
		let c = Configuration(nReal: 15 + 12, nObj: 2, minReal: minCrops + minTenvf, maxReal: maxCrops + maxTenvf, optimizationDirection: [.Maximize, .Minimize])
		return c
	}
}
