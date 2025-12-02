import Foundation

struct Day01: AdventDay, Sendable {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String
  let day = 1
  let puzzleName: String = "--- Day \(day) ---"

  init(data: String) {
    self.data = data
  }

   var input: [String] {
      data
         .components(separatedBy: .newlines)
         .map{$0.trimmingCharacters(in: .whitespacesAndNewlines)}
         .filter{!$0.isEmpty}
   }

  // Replace this with your solution for the first part of the day's challenge.
   func part1() async throws -> Int {
      process1(input)
   }
   func part2() async throws -> Int {
      process2(input)
   }
   
}

// Add any extra code and types in here to separate it from the required behaviour
extension Day01 {
   func process1(_ lines: [String]) -> Int {
      var pointer = 50
      var count = 0
      for line in lines {
         switch line.prefix(1) {
            case "L": pointer -= Int(line.dropFirst())!
            case "R": pointer += Int(line.dropFirst())!
            default: fatalError()
         }
         if pointer % 100 == 0 {
            count += 1
         }
      }
      return count
   }
   
   func process2(_ lines: [String]) -> Int {
      var pointer = 50
      var count = 0
      for line in lines {
         let direction = line.prefix(1)
         let turn = Int(line.dropFirst())!
         switch direction {
            case "L":
               if turn >= pointer {
                  count += abs(pointer-turn) / 100 + 1 - (pointer == 0 ? 1 : 0)
                  pointer = pointer - (turn % 100) + 100
               } else {
                  pointer -= turn
               }
            case "R":
               count += (pointer + turn) / 100
               pointer = (pointer + turn)
            default: fatalError()
         }
         pointer = pointer % 100
      }
      return count
   }
   //3502 too low
   //6448 too high
   
}
