import Testing
import AoCTools

@testable import AdventOfCode

@Suite("Day03 Tests")
struct Day03Tests {
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
         let day = Day03(data: testInput)
         
         @Test("Part1 example")
         func testPart1() async throws {
            let result = try await day.part1()
            #expect(result == 357)
         }
         
         @Test("Part2 example")
         func testPart2() async throws {
            let result = try await day.part2()
            #expect(result == 3121910778619)
         }
      }
   }
}

private let testInput =
"""
987654321111111
811111111111119
234234234234278
818181911112111
"""
