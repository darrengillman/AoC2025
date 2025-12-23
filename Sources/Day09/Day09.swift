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
   
   private enum placement: Equatable {
      case inside
      case outside
   }

   
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
      let polygon = RectilinearPolygon(vertices: vertices + [vertices.first!])

      let combinations = vertices
         .combinations(ofCount: 2)
         .filter{$0[0] != $0[1]}
         .sorted{$0.volume > $1.volume}

      var biggest = 0

      for pair in combinations {
         // Generate all 4 corners of the rectangle
         let corners = [
            pair[0],
            pair[1],
            Point(pair[0].x, pair[1].y),
            Point(pair[1].x, pair[0].y)
         ]

         guard corners.allSatisfy({polygon.contains($0)}) else {
            continue
         }

         // Check if ANY edge passes through rectangle interior
         let hasIntersection = polygon.edges.contains { edge in
            edge.intersects(rectangleWith: pair[0], p2: pair[1])
         }
         
         if !hasIntersection {
            biggest = max(biggest, pair.volume)
         }
      }

      return biggest
   }

   func parse(_ str: String) -> [Point] {
      str
         .components(separatedBy: .newlines)
         .map{$0.components(separatedBy: ",")}
         .map{Point($0.first!.asInt!, $0.last!.asInt!)}
   }
}

struct PolygonEdge {
   let range: ClosedRange<Int>  // The varying dimension (Y for vertical, X for horizontal)
   let constantCoordinate: Int   // The fixed dimension (X for vertical, Y for horizontal)
   let isVertical: Bool

   init(from: Point, to: Point) {
      if from.x == to.x {
         // Vertical edge - x is constant, y varies
         self.isVertical = true
         self.constantCoordinate = from.x
         self.range = Swift.min(from.y, to.y)...Swift.max(from.y, to.y)
      } else {
         // Horizontal edge - y is constant, x varies
         self.isVertical = false
         self.constantCoordinate = from.y
         self.range = Swift.min(from.x, to.x)...Swift.max(from.x, to.x)
      }
   }

   func intersects(rectangleWith p1: Point, p2: Point) -> Bool {
      let rectXRange = Swift.min(p1.x, p2.x)...Swift.max(p1.x, p2.x)
      let rectYRange = Swift.min(p1.y, p2.y)...Swift.max(p1.y, p2.y)
      
      if isVertical {
            // Vertical edge - constantCoordinate is X, range is Y
            // check if vertical is somewhere inside the rect's horizontal edge =>
         guard rectXRange.count > 2 && rectYRange.count > 2 else {
            return false
         }
         let rectXInnerRange = rectXRange.lowerBound+1 ... rectXRange.upperBound-1
         let rectYInnerRange = rectYRange.lowerBound+1 ... rectYRange.upperBound-1
         guard rectXInnerRange.contains(constantCoordinate) else {
            return false
         }
         
         if range.overlaps(rectYInnerRange) {
            return true
         } else {
            return false
         }
      } else {
         // Horizontal edge - constantCoordinate is Y, range is X
         // Check if Y is strictly inside rectangle (not on boundary)
         guard rectXRange.count > 2 && rectYRange.count > 2 else {
            return false
         }
         let rectXInnerRange = rectXRange.lowerBound+1 ... rectXRange.upperBound-1
         let rectYInnerRange = rectYRange.lowerBound+1 ... rectYRange.upperBound-1

         guard rectYInnerRange.contains(constantCoordinate) else {
            return false
         }
         
         if range.overlaps(rectXInnerRange) {
            return true
         } else {
            return false
         }
      }
   }
}

struct RectilinearPolygon {
   let edges: [PolygonEdge]
   let vertices: Set<Point>

   init(vertices: [Point]) {
      var edges: [PolygonEdge] = []
      for window in vertices.windows(ofCount: 2) {
         edges.append(PolygonEdge(from: window.first!, to: window.last!))
      }
      self.edges = edges
      self.vertices = Set(vertices)
   }

   // Check if a point is inside or on the polygon using ray casting
   func contains(_ point: Point) -> Bool {
      // If it's a vertex, it's on the polygon
      if vertices.contains(point) {
         return true
      }

      // Check if point lies on any edge
      for edge in edges {
         if edge.isVertical {
            // Vertical edge - check if point is on this line
            if edge.constantCoordinate == point.x && edge.range.contains(point.y) {
               return true
            }
         } else {
            // Horizontal edge - check if point is on this line
            if edge.constantCoordinate == point.y && edge.range.contains(point.x) {
               return true
            }
         }
      }

      // Ray casting: count vertical edges to the right
      var crossings = 0
      for edge in edges where edge.isVertical {
         // Only count if edge is to the right and at same Y level
         if edge.constantCoordinate > point.x && edge.range.contains(point.y) {
            crossings += 1
         }
      }
      return crossings > 0 && crossings.isMultiple(of: 2) == false
   }
}

extension Array where Element == Point {
   var volume: Int {
      (abs(self[0].x - self[1].x) + 1) * (abs(self[0].y - self[1].y) + 1)
   }
}

// 4747200605 wrong
