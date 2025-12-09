import Testing
import AoCTools

@testable import AdventOfCode

@Suite("Day05 Tests")
struct Day05Tests {
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
         let day = Day05(data: testInput)
         
         @Test("Part1 example")
         func testPart1() async throws {
            let result = try await day.part1()
            #expect(result == 3)
         }
         
         @Test("Part2 example")
         func testPart2() async throws {
            let result = try await day.part2()
            #expect(result == 14)
         }
      }
   }
}

private let testInput =
"""
3-5
10-14
16-20
12-18

1
5
8
11
17
32
"""
