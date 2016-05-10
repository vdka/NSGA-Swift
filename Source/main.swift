//
//  main.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 29/12/2015.
//  Copyright © 2015 Ethan Jackwitz. All rights reserved.
//


var basePath = "/Users/Ethan/Source/vdka/NSGA-swift/"
var evaluatorBasePath = basePath + "datafiles/"

let fileList = ["average", "averageUnconstr", "dry", "dryUnconstr", "wet", "wetUnconstr"]

var evaluatorFile = ""

var resultsPath = basePath + "results/"

for file in fileList {
  let nsgaii = NSGAII<Water>()
  evaluatorFile = evaluatorBasePath + file + ".dat"
  let results = nsgaii.run(generations: 999, popSize: 100)
  writeStringToFile(nsgaii.archive.toCSV(), path: resultsPath + file + ".csv")
  nsgaii.archive.toCSV()
}
