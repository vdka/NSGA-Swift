
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
    "dryCotton",
    "averageCotton",
    "wetCotton",
    "dryCottonCyclic",
    "averageCottonCyclic",
    "wetCottonCyclic",
    //"average",
    //"averageUnconstr", "averageCyclic",
    //"dry",
    //"dryUnconstr", "dryCyclic",
    //"wet",
    //"wetUnconstr", "wetCyclic"
]

struct DataFile {
    
    var path: String
    var contents: String
    var lines: [String]
    var tenvfs: [F]
    var maxCropSize: F
    var nCrops: Int
    static var current: DataFile?
    
    init(path: String) {
        self.path = path
        self.contents = readStringFromFile(path: path)
        self.lines = contents.characters.split(separator: "\n").map(String.init).filter({ !$0.isEmpty })
        
        self.nCrops = Int(lines[0].trimmingCharacters(in: .whitespacesAndNewlines))!

        
        self.maxCropSize = lines[1]
            .characters.split(separator: " ").map(String.init).filter({ !$0.isEmpty })
            .flatMap({ F($0) }).last!
        
        self.tenvfs = lines[3]
            .characters.split(separator: " ").map(String.init).filter({ !$0.isEmpty })
            .flatMap({ F($0) })
    }
}

guard createDirectory(path: resultsPath) else { fatalError("Failed to make directory \(resultsPath)") }

let configSummary =
    [
        "Seed value: \(CommandLine.arguments[2])",
        "Number of Generations: \(nGenerations)",
        "Population Size: \(popSize)",
        "nEvaluations: \(nGenerations * popSize + popSize)"
        ].joined(separator: "\n")

_ = writeStringToFile(configSummary, path: resultsPath + "CONFIG.txt")

for file in fileList {
    DataFile.current = DataFile(path: evaluatorBasePath + file + ".dat")
    let nsgaii = NSGAII<Water>()
    let results = nsgaii.run(generations: nGenerations, popSize: popSize)
    _ = writeStringToFile(nsgaii.archive.toCSV(), path: resultsPath + file + ".csv")
}
