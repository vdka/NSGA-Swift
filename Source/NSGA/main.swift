
import SwiftPCG

import Foundation

let usage = [
  "usage: NSGA basePath seed nGenerations popSize",
  " - basePath is the path within which datafiles and results directories exist",
  " - seed is the seed used for the RNG for this run"
].joined(separator: "\n")

guard CommandLine.arguments.count == 5 else { print(usage); exit(1) }

let basePath = CommandLine.arguments[1]

var seedValue: UInt64 = 0

guard
  let seed = UInt64(CommandLine.arguments[2], radix: 16),
  let nGenerations = Int(CommandLine.arguments[3]),
  let popSize = Int(CommandLine.arguments[4])
else { fatalError(usage) }

seedValue = seed

var rng = PCGRand32(state: seedValue)

var evaluatorBasePath = basePath + "/datafiles/"
var resultsPath = basePath + "/results/\(CommandLine.arguments[2])/"

let fileList = [
  "averageCotton",
  //"average",
  //"averageUnconstr", "averageCyclic",
  //"dry", "dryUnconstr", "dryCyclic",
  //"wet", "wetUnconstr", "wetCyclic"
]

var evaluatorFile = ""

guard createDirectory(path: resultsPath) else { fatalError("Failed to make directory \(resultsPath)") }

let configSummary = [CommandLine.arguments[2], "nEvaluations: \(nGenerations * popSize + popSize)"].joined(separator: "\n")
_ = writeStringToFile(configSummary, path: resultsPath + "CONFIG")

for file in fileList {
  let nsgaii = NSGAII<Water>()
  evaluatorFile = evaluatorBasePath + file + ".dat"
  let results = nsgaii.run(generations: nGenerations, popSize: popSize)
  _ = writeStringToFile(nsgaii.archive.toCSV(), path: resultsPath + file + ".csv")
}
