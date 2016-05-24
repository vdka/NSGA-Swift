//
//  main.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 29/12/2015.
//  Copyright © 2015 Ethan Jackwitz. All rights reserved.
//

import SwiftPCG

let usage = [
  "NSGA basePath seed nGenerations popSize",
  " - basePath is the path within which datafiles and results directories exist",
  " - seed is the seed used for the RNG for this run"
].joined(separator: "\n")

guard Process.arguments.count == 5 else { fatalError(usage) }

let basePath = Process.arguments[1]

var seedValue: UInt64 = 0

guard
  let seed = UInt64(Process.arguments[2], radix: 16),
  let nGenerations = Int(Process.arguments[3]),
  let popSize = Int(Process.arguments[4])
else { fatalError(usage) }

seedValue = seed

var rng = PCGRand32(state: seedValue)

//var basePath = "/Users/Ethan/Source/vdka/NSGA-swift/"
var evaluatorBasePath = basePath + "/datafiles/"
var resultsPath = basePath + "/results/"

let fileList = ["average", "averageUnconstr", "dry", "dryUnconstr", "wet", "wetUnconstr"]

var evaluatorFile = ""

for file in fileList {
  let nsgaii = NSGAII<Water>()
  evaluatorFile = evaluatorBasePath + file + ".dat"
  let results = nsgaii.run(generations: nGenerations, popSize: popSize)
  writeStringToFile(nsgaii.archive.toCSV(), path: resultsPath + file + ".csv")
}

