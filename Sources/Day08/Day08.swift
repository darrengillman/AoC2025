import Algorithms
import AoCTools
import Foundation

struct Day08: AdventDay, Sendable {
      // Save your data in a corresponding text file in the `Data` directory.
   let data: String
   let day = 0
   let puzzleName: String = "--- Day \(day) ---"
   
   init(data: String) {
      self.data = data
   }
   
   func part1() async throws -> Int {
      let limit = 1000
      var nextFreeCircuit = 1
      //parse data into 3D points
     
      let pairs = orderedPairs(from: data)
         .prefix(limit)
      
         //transform the closest pairs of points into circuits
      let circuits = pairs
         .reduce(into: [Point3D: Int]() ) {circuits, pair in
            switch (circuits[pair.a], circuits[pair.b]) {
               case let (.some(a), .some(b)):
                  if a != b {
                     circuits[pair.a] = nextFreeCircuit
                     circuits[pair.b] = nextFreeCircuit
                     for (key, value) in circuits where value == a || value == b {
                        circuits[key] = nextFreeCircuit
                     }
                     nextFreeCircuit += 1
                  }
               case let (.some(a), .none):
                  circuits[pair.b] = a
               case let (.none, .some(b)):
                  circuits[pair.a] = b
               case (.none, .none):
                  circuits[pair.a] = nextFreeCircuit
                  circuits[pair.b] = nextFreeCircuit
                  nextFreeCircuit += 1
            }
         }
         //workout the number of £D points in each circuits
      let circuitCounts = circuits
         .values.reduce(into: [Int: Int]()) {dict, value in
            dict[value, default: 0] += 1
         }
         .values
         .sorted(by: >)
      
      let answer = circuitCounts
         .prefix(3)
         .reduce(1, *)
      
      return answer
   }
   
   func part2() async throws -> Int {
      var nextFreeCircuit = 1
      var inUseCircuits: [Int: [Point3D]] = [:]
      var orderedPairs = orderedPairs(from: data)[...]  //[...] to convert into a subsequence to allow popFirst
      var circuits = [Point3D: Int]()
      var loops = 0
      var currentPair: Pair? = nil
      
      while let pair = orderedPairs.popFirst(), (inUseCircuits.count > 1 || loops < 1000) {
         currentPair = pair
         loops += 1
         switch (circuits[pair.a], circuits[pair.b]) {
            case let (.some(circuitA), .some(circuitB)):
               if circuitA != circuitB {
                  circuits[pair.a] = nextFreeCircuit
                  circuits[pair.b] = nextFreeCircuit
                  
                  inUseCircuits[nextFreeCircuit] = ( inUseCircuits[circuitA] ?? []) + (inUseCircuits[circuitB] ?? [])
                  inUseCircuits.removeValue(forKey: circuitA)
                  inUseCircuits.removeValue(forKey: circuitB)
                  
                  for (key, value) in circuits where value == circuitA || value == circuitB {
                     circuits[key] = nextFreeCircuit
                  }
                  nextFreeCircuit += 1
               }
            case let (.some(a), .none):
               circuits[pair.b] = a
               inUseCircuits[a, default: []].append(pair.b)
            case let (.none, .some(b)):
               circuits[pair.a] = b
               inUseCircuits[b, default: []].append(pair.a)
            case (.none, .none):
               circuits[pair.a] = nextFreeCircuit
               circuits[pair.b] = nextFreeCircuit
               inUseCircuits[nextFreeCircuit] = [pair.a, pair.b]
               nextFreeCircuit += 1
         }
      }
      print(loops, currentPair!.a, currentPair!.b)
      return currentPair!.a.x * currentPair!.b.x
   }
}

// Add any extra code and types in here to separate it from the required behaviour
extension Day08 {
   
   private func orderedPairs(from data: String) -> [Pair] {
      data
         .components(separatedBy: .newlines)
         .filter{!$0.isEmpty}
         .map{$0.trimmingCharacters(in: .whitespaces)}
         .map(Point3D.init)
      
         //work out distances between all combination pairs, and take defined # of shortest conections
         .combinations(ofCount: 2)
         .map{Pair.init(a: $0.first!, b: $0.last!)}
         .sorted(using:SortDescriptor(\.distance))
         .array
   }
   
   
   
   class Point3D: Hashable, CustomStringConvertible {
      var description: String {"(\(x),\(y),\(z))"}
      
      static func == (lhs: Day08.Point3D, rhs: Day08.Point3D) -> Bool {
         lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
      }
      
      func hash(into hasher: inout Hasher) {
         hasher.combine(x)
         hasher.combine(y)
         hasher.combine(z)
      }
      
      let x: Int
      let y: Int
      let z: Int
            
      init (_ s: String) {
         let parts = s.components(separatedBy: ",").map{$0.trimmingCharacters(in: .whitespaces)}
         x = (parts[0]).asInt!
         y = (parts[1]).asInt!
         z = (parts[2]).asInt!
      }
      
      func distance(to other: Point3D) -> Int {
         (x-other.x) * (x-other.x) + (y-other.y) * (y-other.y) + (z-other.z) * (z-other.z)
            //sqrt ignore so can work in Ints.  Its only relative distances that matter
      }
   }
   
   private struct Pair {
      let a: Point3D
      let b: Point3D
      
      var distance: Int {
         a.distance(to: b)
      }
   }
}

extension Int {
   var double: Double {Double(self)}
}

extension Double {
   var int: Int {Int(self)}
}
