
var bestNetRevenue: F = -F.infinity {
didSet {
    //print("New best net revenue: \(bestNetRevenue)")
}
}

var bestWetFlowDeficit: F = F.infinity {
didSet {
    //print("New best wet flow deficit: \(bestWetFlowDeficit)")
}
}

var bestDryFlowDeficit: F = F.infinity {
didSet {
    //print("New best dry flow deficit: \(bestDryFlowDeficit)")
}
}

struct Water: ProblemType {

    static var columnNames: [String] = {
        let crops = ["Rice", "Wheat", "Barley", "Maize", "Canola", "Oats", "Soybean", "W_pasture", "S_pasture", "Lucerne", "Vines", "W_veg", "S_veg", "Citrus", "Stone_fruit", "Cotton"]
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
                case .minimize:
                    if ours < theirs { flagOurs = true }
                    if ours > theirs { flagTheirs = true }

                case .maximize:
                    if ours > theirs { flagOurs = true }
                    if ours < theirs { flagTheirs = true }
                }
            }

            switch (flagOurs, flagTheirs) {
            case (true, false): return true
            case (false, true): return false
            default: return .none
            }
        }
    }

    typealias Individual = ConstrainedIndividual

    static let nCrops = 16

    static func argsFor(individual: Individual) -> [String] {
        let realStrings = individual.reals.map {
            //      guard i >= 100 else { return "0" } // clamp values < 100 to 0 WILL SKEW RESULTS
            return Int($0.roundTo(places: 0)).description
        }

        let args: [String] = [evaluatorFile, nCrops.description] + realStrings

        return args
    }

    static func evaluate(individual: inout Individual) {

        let args = argsFor(individual: individual)

        let r = evaluateWater(args)

        let (exitCode, netRevenue, flowDeficit, constraintViolation) = r

        guard exitCode == 0 else { fatalError("evaluator returned with exit code \(exitCode)") }

        // March-August and September-February (the "dry" and "wet seasons".)
        let dryFlowDeficit = [3, 4, 5, 6, 7, 8].map { flowDeficit[$0 - 1] }.reduce(0, +)
        let wetFlowDeficit = [1, 2, 9, 10, 11, 12].map { flowDeficit[$0 - 1] }.reduce(0, +)

        individual.obj = [netRevenue, dryFlowDeficit.clamp(lower: 0, upper: .infinity), wetFlowDeficit.clamp(lower: 0, upper: .infinity)]
        individual.constraintViolation = constraintViolation.clamp(lower: 0, upper: F.infinity)

        if netRevenue < 0 { return }
        if constraintViolation == 0 { return }

//        guard !(netRevenue.sign == .minus) && constraintViolation == 0 else { return }

        if dryFlowDeficit < bestDryFlowDeficit {
            bestDryFlowDeficit = dryFlowDeficit
        }

        if wetFlowDeficit < bestWetFlowDeficit {
            bestWetFlowDeficit = wetFlowDeficit
        }

        if netRevenue > bestNetRevenue {
            bestNetRevenue = netRevenue
        }
    }

    static var config: Configuration {

        let minTenvf: [F] = [0.0].repeated(12)
        let maxTenvf: [F] = [250000.0].repeated(12)
        let minCrops: [F] = [0.0].repeated(nCrops)
        let maxCrops: [F] = [121808.0].repeated(nCrops)

        let c = Configuration(nReal: nCrops + 12, nObj: 3, minReal: minCrops + minTenvf, maxReal: maxCrops + maxTenvf, optimizationDirection: [.maximize, .minimize, .minimize])
        return c
    }
}
