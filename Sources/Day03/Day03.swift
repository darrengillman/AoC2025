//
//  Day02.swift
//  AdventOfCode
//
//  Created by Darren Gillman on 02/12/2025.
//

import AoCTools

struct Day03: AdventDay, Sendable {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String
  let day = 03
  let puzzleName: String = "--- Day \(day) ---"

  init(data: String) {
    self.data = data
  }
   
   var lines:[[Int]] {
      data
         .components(separatedBy: .newlines)
         .filter{$0.isEmpty == false}
         .map{$0.trimmingCharacters(in: .whitespacesAndNewlines)}
         .map{$0.map{(Int($0.asString)!)}}
   }


  // Replace this with your solution for the first part of the day's challenge.
   func part1() async throws -> Int {
      lines.reduce(0) {sum, line in
         sum + process(line, digitsRequired: 2)
      }
   }
   
   func part2() async throws -> Int {
      lines.reduce(0) {sum, line in
         sum + process(line, digitsRequired: 12)
      }

   }
}

extension Day03 {
   func process(_ line: [Int], digitsRequired digits: Int) -> Int {
      var elements = [Int]()
      var index = 0
      for digit in stride(from: digits, through: 1, by: -1) {
         let (max, maxIndex) = processLine(line[index...].array, digit: digit)
         elements.append(max)
         index += maxIndex + 1
      }
      return elements.map{$0.asString}.joined().asInt!
   }
   
   func processLine(_ line: [Int], digit: Int) -> (value: Int, index: Int) {
      let max = line
         .dropLast(digit-1)
         .max()!
      let index = line.firstIndex(of: max)!
      return(max, index)
      
   }
}
