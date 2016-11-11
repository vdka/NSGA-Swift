//
//  Package.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 2/26/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

import PackageDescription

let package = Package(
  name: "NSGA",
  targets: [
    Target(name: "CWaterEvaluator", dependencies: []),
    Target(name: "NSGA", dependencies: ["CWaterEvaluator"])
  ],
  dependencies: [ .Package(url: "git@github.com:VDKA/SwiftPCG.git", majorVersion: 0, minor: 2) ]
)
