//
//  Day02.swift
//  AdventOfCode
//
//  Created by Darren Gillman on 02/12/2025.
//


struct Day05: AdventDay, Sendable {
      // Save your data in a corresponding text file in the `Data` directory.
   let data: String
   let day = 05
   let puzzleName: String = "--- Day \(day) ---"
   let fresh: [ClosedRange<Int>]
   let ingredients: Set<Int>
   
   

  init(data: String) {
    self.data = data
     fresh = data.components(separatedBy: .newlines)
        .filter{$0.contains("-")}
        .map{$0.components(separatedBy: "-")}
        .map{$0.first!.asInt! ... $0.last!.asInt!}
        .sorted{$0.lowerBound < $1.lowerBound}
     
     ingredients = data.components(separatedBy: .newlines)
        .filter{!$0.contains("-") && !$0.isEmpty}
        .reduce(into: Set<Int>()) { $0.insert($1.asInt!)}
     
  }

  // Replace this with your solution for the first part of the day's challenge.
   func part1() async throws -> Int {
      ingredients.filter{ ingredient in
         fresh.contains(where: { $0.contains(ingredient) })
      }
      .count
   }
   
   func part2() async throws -> Int {
      fresh
         .reduce(into: [ClosedRange<Int>]()) { array, range in
            if let index = array.firstIndex(where: {$0.contains(range.lowerBound)}) {
               array[index] = array[index].lowerBound ... max(array[index].upperBound, range.upperBound)
            } else if let index = array.firstIndex(where: {$0.contains(range.upperBound)}) {
               array[index] = min(array[index].lowerBound, range.lowerBound) ... array[index].upperBound
            } else {
               array.append(range)
            }
         }
         .reduce(0){$0 + $1.count}
   }
}
