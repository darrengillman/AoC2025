//
//  Day02.swift
//  AdventOfCode
//
//  Created by Darren Gillman on 02/12/2025.
//

import AoCTools
import Algorithms

struct Day06: AdventDay, Sendable {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String
  let day = 06
  let puzzleName: String = "--- Day \(day) ---"

  init(data: String) {
    self.data = data
  }

  // Replace this with your solution for the first part of the day's challenge.
   func part1() async throws -> Int {
      let input = data
         .components(separatedBy: .newlines)
         .filter{!$0.isEmpty}
         .map{$0.split(separator: " ", omittingEmptySubsequences: true)}
      
      var sum = 0
      for i in 0..<input.first!.count {
         sum += calculate(
            values: input[0...input.count-2].map{$0[i].asString.asInt!},
            operation: input.last![i].asString
         )
      }
      return sum
   }


   func part2() async throws -> Int {
      let input = data
         .components(separatedBy: .newlines)
         .filter{!$0.isEmpty}
         .map{
            $0.map{$0.asString}
         }
      
      return input
         .first!
         .indices
         .map{ index in
            input
               .map{$0[index]
                     .replacingOccurrences(of: " ", with: "")
               }
         }
         .map{$0.joined()}
         .split(separator: "")
         .map(Array.init)
         .reduce(0){$0 + process($1)}
   }
}

extension Day06 {
   func process(_ strings: [String]) -> Int {
      guard let op = strings.first?.last, ["+", "*"].contains(op) else {
         fatalError()
      }
      return strings
         .map{
            $0.trimmingCharacters(in: .decimalDigits.inverted)
               .asInt!
         }
         .reduce(op == "+" ? 0: 1){ op == "+" ? $0 + $1 : $0 * $1}
   }
   
   func calculate(values: [Int], operation: String) -> Int {
      switch operation {
         case "+": values.reduce(0, +)
         case "*": values.reduce(1, *)
         default: fatalError()
      }
   }
   
   
}
