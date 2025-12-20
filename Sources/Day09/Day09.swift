//
//  Day02.swift
//  AdventOfCode
//
//  Created by Darren Gillman on 02/12/2025.
//

import AoCTools
import Algorithms

struct Day09: AdventDay, Sendable {
      // Save your data in a corresponding text file in the `Data` directory.
   let data: String
   let day = 99
   let puzzleName: String = "--- Day \(day) ---"
   
   init(data: String) {
      self.data = data
   }
   
      // Replace this with your solution for the first part of the day's challenge.
   func part1() async throws -> Int {
      data
         .components(separatedBy: .newlines)
         .map{$0.components(separatedBy: ",")}
         .map{Point($0.first!.asInt!, $0.last!.asInt!)}
         .combinations(ofCount: 2)
         .map{
            abs(
               $0[0].x - $0[1].x + 1
            ) * abs(
               $0[0].y - $0[1].y + 1
            )
         }
         .max()!
   }
   
   func part2() async throws -> Int {
      let vertices = parse(data)
      
      let polygonOutline = polygonOutline(from: vertices + [vertices.first!])

      let xRange = vertices.map(\.x).min()!...vertices.map(\.x).max()!
      let yRange = vertices.map(\.y).min()!...vertices.map(\.y).max()!
      
      let allPoints = [Point.init(xRange.lowerBound, yRange.lowerBound), Point.init(xRange.upperBound, yRange.upperBound)]
         .pointsInside()
      
      let redOrGreen = generateRedOrGreen(from: allPoints, withPolygon: polygonOutline)
      
      return vertices
         .combinations(ofCount: 2)
         .filter{$0[0] != $0[1]}
         .filter{ rect in
            rect
               .pointsInside()
               .isSubset(of: redOrGreen)
         }
         .map{
            abs(
               $0[0].x - $0[1].x + 1
            ) * abs(
               $0[0].y - $0[1].y + 1
            )
         }
         .max()!
   }
   
   func polygonOutline(from vertices: [Point]) -> [Point: String] {
      vertices
         .windows(ofCount: 2)
         .reduce(into: [Point: String]() ) { dict, pair in
            let first = pair.first!
            let last = pair.last!
            if first.x == last.x {
               for c in min(first.y, last.y)...max(first.y, last.y)  {
                  let point = Point(first.x, c)
                  if dict[point] == nil {
                     dict[point] = "G"
                  }
               }
            } else {
               for c in min(first.x, last.x)...max(first.x, last.x)  {
                  let point = Point(c, first.y)
                  if dict[point] == nil {
                     dict[point] = "G"
                  }
               }
            }
            dict[first] = "R"
         }
   }
   
   func parse(_ str: String) -> [Point] {
      str
         .components(separatedBy: .newlines)
         .map{$0.components(separatedBy: ",")}
         .map{Point($0.first!.asInt!, $0.last!.asInt!)}
   }
   
   func generateRedOrGreen(from points: Set<Point>, withPolygon outline: [Point: String]) -> Set<Point> {
      points
         .reduce(into: Set<Point>()) { set, point in
            if outline.keys.contains(point) {
               set.insert(point)
            } else if outline.isPointInRectilinearPolygon(point: point) {
               set.insert(point)
            }
         }
   }

}

private extension Dictionary where Key == Point, Value: StringProtocol {
   func isPointInRectilinearPolygon(point: Point) -> Bool {
      let n = keys.count
      guard n >= 4 else { return false }

      var crossings = 0

      // Only count vertical edges - check points to the right at same y-level
      for key in self.keys where key.y == point.y && key.x > point.x {
         // Check if this point is part of a vertical edge
         let hasPointAbove = self.keys.contains(Point(key.x, key.y + 1))
         let hasPointBelow = self.keys.contains(Point(key.x, key.y - 1))

         // Only count if it's part of a vertical edge
         if hasPointAbove || hasPointBelow {
            crossings += 1
         }
      }

      return crossings > 0 && crossings.isMultiple(of: 2) == false
   }
}

extension Array where Element == Point{
   func pointsInside() -> Set<Point> {
      guard self.count >= 2 else {return []}
      let xr = self.map(\.x).min()! ... self.map( \.x).max()!
      let yr = self.map(\.y).min()! ... self.map( \.y).max()!
      var inside = Set<Point>()
      
      for y in yr {
         for x in xr {
            inside.insert(.init( x, y))
         }
      }
      
      return inside
   }
}


