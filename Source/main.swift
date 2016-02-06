//
//  main.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 29/12/2015.
//  Copyright © 2015 Ethan Jackwitz. All rights reserved.
//

let nsgaii = NSGAII<Simple, ZDT4>()

nsgaii.run(generations: 2000, popSize: 8)
