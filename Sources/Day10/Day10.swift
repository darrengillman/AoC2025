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
   
}

   // Add any extra code and types in here to separate it from the required behaviour
extension Day10 {
   struct Machine: Hashable {
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
      
      func hash(into hasher: inout Hasher) {
         hasher.combine(state)
         hasher.combine(buttons)
      }
      
      let indicatorTarget: [State]
      let joltageTarget: [Int]
      let buttons: [Set<Int>]
      var state: [State]
      var joltages: [Int]
      
      var registersComplete: Bool {state == indicatorTarget}
      var joltageCorrect: Bool {joltageTarget == joltages}
      
      init(target: [Day10.Machine.State], joltageTarget: [Int], buttons: [Set<Int>], state: [Day10.Machine.State], joltages: [Int] = []) {
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
                  .set
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
