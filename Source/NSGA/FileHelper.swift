//
//  FileHelper.swift
//  NSGA-II
//
//  Created by Ethan Jackwitz on 5/11/16.
//  Copyright © 2016 Ethan Jackwitz. All rights reserved.
//

#if os(Linux)
  import Glibc
#else //likely Darwin
  import Darwin.C
#endif

func bytesFrom(string: String) -> [UInt8] {
  return Array(string.utf8)
}

// Convert UInt8 bytes to String
func stringFromBytes(bytes: UnsafeMutablePointer<UInt8>, count: Int) -> String {
  return String((0..<count).map ({ Character(UnicodeScalar(bytes[$0])) }))
}

// Use fopen/fwrite to output string
func writeStringToFile(_ string: String, path: String) -> Bool {
  let fp = fopen(path, "w"); defer { fclose(fp) }
  let byteArray = bytesFrom(string: string)
  let count = fwrite(byteArray, 1, byteArray.count, fp)
  return count == string.utf8.count
}
