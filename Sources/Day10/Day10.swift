   //
   //  Day00.swift
   //  AdventOfCode
   //
   //  Created by Darren Gillman on 26/12/2025.
   //

/*
 [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
 [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
 [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
 */

import Algorithms
import Foundation

struct Day10: AdventDay, Sendable {
      // Save your data in a corresponding text file in the `Data` directory.
   let data: String
   let day = 10
   let puzzleName: String = "--- Day \(day) ---"
   
   init(data: String) {
      self.data = data
   }
   
      // Replace this with your solution for the first part of the day's challenge.
   func part1() async throws -> Int {
      let baseMachines = parse(data)
      var total = 0
      
      for base in baseMachines {
         var level = 0
         var machines: Set<Machine> = Set(arrayLiteral: base)
         while machines.allSatisfy({!$0.registersComplete}) {
            level += 1
            machines = machines.flatMap{$0.applyingButtons()}.set
         }
         total += level
      }
      return total
   }
   
   func part2() async throws -> Int {
      let baseMachines = parse(data)
      return baseMachines.map { $0.solve() }.reduce(0, +)
   }
   
}

   // Add any extra code and types in here to separate it from the required behaviour
extension Day10 {
   enum State: String, CustomStringConvertible {
      case on = "#"
      case off = "."
      
      var description: String {
         return switch self {
            case .on: "#"
            case .off: "."
         }
      }
      
      func toggled() -> Self {
         self == .off ? .on : .off
      }
   }

   struct Machine: Hashable {
      
      func hash(into hasher: inout Hasher) {
         hasher.combine(state)
         hasher.combine(buttons)
      }
      
      let indicatorTarget: [State]
      let joltageTarget: [Int]
      let buttons: [[Int]]
      var state: [State]
      var joltages: [Int]
      
      var registersComplete: Bool {state == indicatorTarget}
      var joltageCorrect: Bool {joltageTarget == joltages}
      
      init(target: [Day10.State], joltageTarget: [Int], buttons: [[Int]], state: [Day10.State], joltages: [Int] = []) {
         self.indicatorTarget = target
         self.joltageTarget = joltageTarget
         self.buttons = buttons
         self.state = state
         self.joltages = joltages
      }
      
      init(string: String) {
         let targetRegex = /^\[([.#]+)\]/
         let buttonRegex = /\(([0-9,]+)\)/
         let costRegex = /\{([\d,]+)\}$/
         
         indicatorTarget = string
            .firstMatch(of: targetRegex)!
            .output
            .1
            .map{State(rawValue: $0.asString)!}
         
         buttons = string
            .matches(of: buttonRegex)
            .map{ match in
               match.output.1
                  .components(separatedBy: ",")
                  .map{$0.asInt!}
            }
         
         joltageTarget = string
            .firstMatch(of: costRegex)!
            .output
            .1
            .components(separatedBy: ",")
            .map{$0.asString.asInt!}
         
         state = Array(repeating: .off, count: indicatorTarget.count)
         joltages = Array(repeating: 0, count: joltageTarget.count)
         
      }
      
      func applyingButtons() -> [Machine] {
         buttons.map{ button in
            return Machine(
               target: self.indicatorTarget,
               joltageTarget: self.joltageTarget,
               buttons: self.buttons.filter{$0 != button},
               state: self.state.indices.map{ index in
                  button.contains(index) ? state[index].toggled() : state[index]
               }
            )
         }
      }
      
      func applyJoltage()  -> [Machine] {
         buttons.map{ button in
            return Machine(
               target: self.indicatorTarget,
               joltageTarget: self.joltageTarget,
               buttons: self.buttons,
               state: self.state,
               joltages: self.joltages.indices.map{ index in
                  button.contains(index) ? joltages[index] + 1 : joltages[index]
               }
            )
         }
      }
   }
   
   private func parse(_ data: String) -> [Machine] {
      data
         .components(separatedBy: .newlines)
         .filter{!$0.isEmpty}
         .map(Machine.init)
   }
}
extension Day10.Machine { //for pt2
   
   func cartesianProduct(values: [Int], repeatCount: Int) -> [[Int]] {
      guard repeatCount > 0 else { return [[]] }
      
      var result: [[Int]] = [[]]
      for _ in 0..<repeatCount {
         var newResult: [[Int]] = []
         for existing in result {
            for value in values {
               newResult.append(existing + [value])
            }
         }
         result = newResult
      }
      return result
   }
   
   func patterns(binaryButtons: [[Int]]) -> [[Int]: [[Int]: Int]] {
      let numButtons = binaryButtons.count
      let numVariables = binaryButtons[0].count
      
      var out: [[Int]: [[Int]: Int]] = [:]
      
         // Initialize with all parity patterns
      for parityPattern in cartesianProduct(values: [0, 1], repeatCount: numVariables) {
         out[parityPattern] = [:]
      }
      
      for numPressedButtons in 0...numButtons {
         for buttons in (0..<numButtons).combinations(ofCount: numPressedButtons) {
               // Calculate pattern by summing coefficients
            var pattern = Array(repeating: 0, count: numVariables)
            for button in buttons {
               for j in 0..<numVariables {
                  pattern[j] += binaryButtons[button][j]
               }
            }
            
               // Calculate parity pattern
            let parityPattern = pattern.map { $0 % 2 }
            
            if out[parityPattern]![pattern] == nil {
               out[parityPattern]![pattern] = numPressedButtons
            }
         }
      }
      
      return out
   }
   
   
   
   
   func solveSingle(buttons: [[Int]], target: [Int]) -> Int {
      var cache: [[Int]: Int] = [:]
      
      let bButs = buttons.map { r in
         (0..<joltageTarget.count).map { i in r.contains(i) ? 1 : 0 }
      }
      
      let patternCosts = patterns(binaryButtons: bButs)
      
      func solveSingleAux(target: [Int]) -> Int {
         guard cache[target] == nil else {
            return cache[target]!
         }
         
         guard !target.allSatisfy({ $0 == 0 }) else {
            return 0
         }
         
         var answer = 1_000_000
         let parityPattern = target.map { $0 % 2 }
         
         if let patterns = patternCosts[parityPattern] {
            for (pattern, patternCost) in patterns {
                  // Check if pattern[i] <= goal[i] for all i
               let valid = zip(pattern, target).allSatisfy { $0 <= $1 }
               
               if valid {
                  let newGoal = zip(pattern, target).map { (i, j) in (j - i) / 2 }
                  let subAnswer = solveSingleAux(target: newGoal)
                  answer = min(answer, patternCost + 2 * subAnswer)
               }
            }
         }
         
         cache[target] = answer
         return answer
      }

      

      return solveSingleAux(target: target)
      
      
      
   }
   
   func solve() -> Int {

      
      return solveSingle(buttons: buttons, target: joltageTarget)

   }
}

