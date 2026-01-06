//
//  Day10Tests 2.swift
//  AdventOfCode
//
//  Created by Darren Gillman on 06/01/2026.
//


import Testing
import AoCTools

@testable import AdventOfCode

@Suite("Day11 Tests")
struct Day11Tests {
   @Suite("Parser Tests")
   struct ParserTests {
      @Test("Test parser implementation")
      func parseInput() {
            //
      }
   }
   
   @Suite("Tests on sample inputs")
   struct SolutionsTests {
      @Suite("Tests on sample inputs")
      struct SolutionsTests {
         
         @Test("Part1 example")
         func testPart1() async throws {
            let day = Day11(data: testInput1)
            let result = try await day.part1()
            #expect(result == 5)
         }
         
         @Test("Part2 example")
         func testPart2() async throws {
            let day = Day11(data: testInput2)
            let result = try await day.part2()
            #expect(result == 2)
         }
      }
   }
}

private let testInput1 =
  """
  aaa: you hhh
  you: bbb ccc
  bbb: ddd eee
  ccc: ddd eee fff
  ddd: ggg
  eee: out
  fff: out
  ggg: out
  hhh: ccc fff iii
  iii: out
  """

private let testInput2 =
"""
svr: aaa bbb
aaa: fft
fft: ccc
bbb: tty
tty: ccc
ccc: ddd eee
ddd: hub
hub: fff
eee: dac
dac: fff
fff: ggg hhh
ggg: out
hhh: out
"""
