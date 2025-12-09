import Testing
import AoCTools

@testable import AdventOfCode

@Suite("Day06 Tests")
struct Day06Tests {
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
         let day = Day06(data: testInput)
         
         @Test("Part1 example")
         func testPart1() async throws {
            let result = try await day.part1()
            #expect(result == 4277556)
         }
         
         @Test("Part2 example")
         func testPart2() async throws {
            let result = try await day.part2()
            #expect(result == 3263827)
         }
      }
   }
}

private let testInput =
"""
123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  
"""
