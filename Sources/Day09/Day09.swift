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
      let indexedPolygon = IndexedPolygon(outline: polygonOutline)

      let combinations = vertices
         .combinations(ofCount: 2)
         .filter{$0[0] != $0[1]}
         .sorted{$0.volume > $1.volume}

      var biggest = 0
      var index = 0

      while combinations[index].volume > biggest {
         let pair = combinations[index]
         if pair.isRectangleInside(indexedPolygon: indexedPolygon) {
            biggest = pair.volume
         }
         index += 1
      }
      return biggest
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
}

struct IndexedPolygon {
   let outline: [Point: String]
   let pointsByY: [Int: [Point]]  // Pre-grouped by Y coordinate for fast lookup

   init(outline: [Point: String]) {
      self.outline = outline
      // Group all outline points by their Y coordinate (done once)
      self.pointsByY = Dictionary(grouping: outline.keys, by: { $0.y })
   }

   func isPointInside(_ point: Point) -> Bool {
      // On outline? It's inside
      if outline.keys.contains(point) { return true }

      guard outline.keys.count >= 4 else { return false }

      var crossings = 0

      // Only check keys at this specific Y level (much faster!)
      if let keysAtThisY = pointsByY[point.y] {
         for key in keysAtThisY where key.x > point.x {
            // Check if this point is part of a vertical edge
            let hasPointAbove = outline.keys.contains(Point(key.x, key.y + 1))
            let hasPointBelow = outline.keys.contains(Point(key.x, key.y - 1))

            // Only count if it's part of a vertical edge
            if hasPointAbove || hasPointBelow {
               crossings += 1
            }
         }
      }

      return crossings > 0 && crossings.isMultiple(of: 2) == false
   }
}

private extension Dictionary where Key == Point, Value: StringProtocol {
   func isPointInRectilinearPolygon(point: Point) -> Bool {
      if self.keys.contains(point) { return true }
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
   var volume: Int {
      abs(
         self[0].x - self[1].x + 1
      ) * abs(
         self[0].y - self[1].y + 1
      )
   }

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

   // Check if all points in rectangle are inside polygon without creating Set
   func isRectangleInside(polygon: [Point: String]) -> Bool {
      guard self.count == 2 else { return false }
      let p1 = self[0]
      let p2 = self[1]
      let xRange = Swift.min(p1.x, p2.x)...Swift.max(p1.x, p2.x)
      let yRange = Swift.min(p1.y, p2.y)...Swift.max(p1.y, p2.y)

      for y in yRange {
         for x in xRange {
            if !polygon.isPointInRectilinearPolygon(point: Point(x, y)) {
               return false  // Early exit when point is outside
            }
         }
      }
      return true
   }

   // Optimized version using indexed polygon
   func isRectangleInside(indexedPolygon: IndexedPolygon) -> Bool {
      guard self.count == 2 else { return false }
      let p1 = self[0]
      let p2 = self[1]
      let xRange = Swift.min(p1.x, p2.x)...Swift.max(p1.x, p2.x)
      let yRange = Swift.min(p1.y, p2.y)...Swift.max(p1.y, p2.y)
      
      let edges = (
         xRange.map{[Point($0, p1.y), Point($0, p2.y)]}
         + (yRange).map{[Point(p1.x, $0), Point(p2.x, $0)]}
      )
         .flatMap{$0}
      
      for point in edges {
         if !indexedPolygon.isPointInside(point) {
            return false  // Early exit when point is outside
         }
      }
      return true
   }
}

