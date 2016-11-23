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

// Use fread to input string
func readStringFromFile(path: String) -> String {
    let fp = fopen(path, "r"); defer {fclose(fp)}
    var outputString = ""
    let chunkSize = 1024
    let buffer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer.allocate(capacity: chunkSize); defer {buffer.deallocate(capacity: chunkSize)}
    repeat {
        let count: Int = fread(buffer, 1, chunkSize, fp)
        guard ferror(fp) == 0 else {break}
        if count > 0 {
            outputString += stringFromBytes(bytes: buffer, count: count)
        }
    } while feof(fp) == 0
    
    return outputString
}

func createDirectory(path: String) -> Bool {

    let result = mkdir(path, S_IRWXU | S_IRWXG | S_IRWXO)

    guard result == 0 || errno == EEXIST else {
        return false
    }
    
    return true
}

