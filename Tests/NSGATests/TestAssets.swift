//
//  TestAssets.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 4/12/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

var testPoints: [Point] = {
  return (0...1_000).map { _ in
    return Point(x: Int.random(), y: Int.random())
  }
}()
