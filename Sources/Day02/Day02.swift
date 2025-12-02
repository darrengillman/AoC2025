//
//  Day00.swift
//  AdventOfCode
//
//  Created by Darren Gillman on 02/12/2025.
//


struct Day02: AdventDay, Sendable {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String
  let day = 2
  let puzzleName: String = "--- Day \(day) ---"

  init(data: String) {
    self.data = data
  }

  // Replace this with your solution for the first part of the day's challenge.
   func part1() async throws -> Int {
      data
         .trimmingCharacters(in: .whitespacesAndNewlines)
         .components(separatedBy: ",")
         .map(IDRange.init)
         .map{$0.check1()}
         .reduce(0, +)
   }
   // 578505 too low
   
   
   func part2() async throws -> Int {
      data
         .trimmingCharacters(in: .whitespacesAndNewlines)
         .components(separatedBy: ",")
         .map(IDRange.init)
         .map{$0.check2()}
         .reduce(0, +)
   }
}

// Add any extra code and types in here to separate it from the required behaviour
extension Day02 {
   struct IDRange {
      var range: ClosedRange<Int>
      
      init(_ string: String) {
         let ints = string
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "-")
            .compactMap(Int.init)
         range = ints[0]...ints[1]
      }
      
      func check1() -> Int {
         range.reduce(0) {sum, item in
            let s = item.asString
            guard s.count.isMultiple(of: 2) else {return sum}
            let left = s.prefix(s.count/2)
            let right = s.suffix(s.count/2)
            if left == right  {
               return sum + item
            } else {
               return sum
            }
         }
      }
      
      func check2() -> Int {
         range.reduce(0) {sum, item in
            let s = item.asString
//            print(s, s.matches(of: /^(.+)\1+$/), s.matches(of: /^(.+)\1+$/).first?.output)
            if s.matches(of: /^(\d+)\1+$/).isEmpty == false {
               return sum + item
            } else {
               return sum
            }
         }
      }
   }
}

