//
//  Day02.swift
//  AdventOfCode
//
//  Created by Darren Gillman on 02/12/2025.
//

import AoCTools

struct Day07: AdventDay, Sendable {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String
  let day = 07
  let puzzleName: String = "--- Day \(day) ---"

  init(data: String) {
    self.data = data
  }

   func part1() async throws -> Int {
      let input = data.components(separatedBy: .newlines).filter{!$0.isEmpty}.map{$0.map{$0}}
      let start = input.first!.firstIndex(of: "S")!
      let rows = input.dropFirst().asArray()
      let range = 0..<rows.first!.count
      var beams: [Set<Int>] = [[start]]
      var splits = 0
      for row in rows {
         var emitted: Set<Int> = []
         for beam in beams.last! {
            if row[beam] == "." {
               emitted.insert(beam)
            } else {
               let newBeams = [beam + 1, beam - 1].filter{range ~= $0}
               if !newBeams.isEmpty {
                  emitted = emitted.union(newBeams)
                  splits += 1
               }
            }
         }
         beams.append(emitted)
      }
      return splits
   }
      
   func part2() async throws -> Int {
      let input = data.components(separatedBy: .newlines).filter{!$0.isEmpty}.map{$0.map{$0}}
      let start = input.first!.firstIndex(of: "S")!
      let rows = input.dropFirst().asArray()
      
      var paths: [Int: Int] = [start: 1]
      
      for row in rows {
         let splitters = row.indices.filter{row[$0] == "^"}

         for split in splitters {
            if let waysIn = paths[split] {
               paths[split + 1] = paths[split + 1, default: 0] + waysIn
               paths[split - 1] = paths[split - 1, default: 0] + waysIn
            }
            paths[split] = nil
         }
      }
      return paths.values.reduce(0, +)
   }
}
