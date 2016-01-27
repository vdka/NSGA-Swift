//
//  Crossover.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 1/26/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

protocol Genetic {
	var reals: [Double] { get set }
}

func crossoverReals<U>(chance: Double, parentsReals: ([U], [U])) -> ([U], [U]) {
	
	guard parentsReals.0.count == parentsReals.1.count else { fatalError() }
	guard Bool.random(chance) else { return parentsReals }
	
	var (pa, pb) = parentsReals
	var (ca, cb): ([U], [U]) = ([], [])
	
	let splitIndex = Int.random(1, parentsReals.0.endIndex - 1)
	
	let (aa, ab) = (Array(pa[0..<splitIndex]), Array(pa[splitIndex..<pa.endIndex]))
	let (ba, bb) = (Array(pb[0..<splitIndex]), Array(pb[splitIndex..<pb.endIndex]))
	
	ca = aa + bb
	cb = ba + ab
	
	return (ca, cb)
}
