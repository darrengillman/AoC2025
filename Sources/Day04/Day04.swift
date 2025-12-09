//
//  Day02.swift
//  AdventOfCode
//
//  Created by Darren Gillman on 02/12/2025.
//
import AoCTools

struct Day04: AdventDay, Sendable {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String
  let day = 04
  let puzzleName: String = "--- Day \(day) ---"

  init(data: String) {
    self.data = data
  }
   
   let roll: Character = "@"

  // Replace this with your solution for the first part of the day's challenge.
   func part1() async throws -> Int {
      let lines = parse(data)
      let grid = Grid(lines: lines)
      
      return grid
         .grid
         .values
         .reduce(into: 0){sum, node in
            if node.content == roll && canRemove(node.point, from: grid.grid) {
               sum += 1
            }
         }
   }

   func part2() async throws -> Int {
      let lines = parse(data)
      var grid = Grid(lines: lines)
      var pool: Set<Point> = grid.points.set
      var count: Int = 0
            
      while let point = pool.popFirst() {
         if (grid.grid[point]?.content == roll) && canRemove(point, from: grid.grid){
            count += 1
            pool = pool.union(point.pointsHVD.filter(grid.isValid))
            grid.set(point, to: nil)
         }
      }
      return count
   }
}


extension Day04 {
   private func canRemove(_ point: Point, from grid: [Point: Node]) -> Bool {
      guard let node = grid[point] else {return false}
      if node.point.pointsHVD.compactMap({ grid[$0]?.content }).count(where: {$0 == roll}) < 4 {
         return true
      }
      return false
   }
}
