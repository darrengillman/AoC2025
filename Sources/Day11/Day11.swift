import AoCTools
import Foundation

struct Day11: AdventDay, Sendable {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String
  let day = 0
  let puzzleName: String = "--- Day \(day) ---"

  init(data: String) {
    self.data = data
  }
   


  // Replace this with your solution for the first part of the day's challenge.
   func part1() async throws -> Int {
      func calcRoutes(from: String) -> Int {
         if let number = routeCache[from] {
            return number
         }
         
         guard let next = directions[from] else {return 0}
         
         if next.first! == "out" {
            return 1
         }
         
         let count = next
            .reduce(0){ $0 + calcRoutes(from: $1)
         }
         routeCache[from] = count
         return count
      }
                  
      var routeCache: [String: Int] = [:]

      let directions = data
         .components(separatedBy: .newlines)
         .filter{!$0.isEmpty}
         .map{$0.firstMatch(of: /(\w{3}):\s+(.*)/)}
         .reduce(into: [String:[String]]()) { dict, match in
            dict[match!.output.1.asString] = match!.output.2.components(separatedBy: .whitespaces)
         }
      
      return calcRoutes(from: "you")
   }
   
   func part2() async throws -> Int {
      func calcRoutes(from: String, dac: Bool, fft: Bool ) -> Int {
         if let cached = routeCache[from], cached.1 == dac, cached.2 == fft {
            return cached.0
         }
         
         guard let next = directions[from] else {return 0}
         
         if next.first! == "out" {
            if dac && fft {
               return 1
            } else {
               return 0
            }
         }
         let count = next
            .reduce(0){
               $0 + calcRoutes(from: $1, dac: dac || $1 == "dac", fft: fft || $1 == "fft")
            }
         routeCache[from] = (count, dac, fft)
         return count
      }
      
      var routeCache: [String: (Int, Bool, Bool)] = [:]
      
      let directions = data
         .components(separatedBy: .newlines)
         .filter{!$0.isEmpty}
         .map{$0.firstMatch(of: /(\w{3}):\s+(.*)/)}
         .reduce(into: [String:[String]]()) { dict, match in
            dict[match!.output.1.asString] = match!.output.2.components(separatedBy: .whitespaces)
         }
      
      return calcRoutes(from: "svr", dac: false, fft: false)
   }
   
}

// Add any extra code and types in here to separate it from the required behaviour
extension Day11 {
   
}
