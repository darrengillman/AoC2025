import Testing
import AoCTools

@testable import AdventOfCode

@Suite("Day01 Tests")
struct Day01Tests {
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
         let day = Day01(data: testInput)
         
         @Test("Part1 example")
         func testPart1() async throws {
            let result = try await day.part1()
            #expect(result == 3)
         }
         
         @Test("Part2 example")
         func testPart2() async throws {
            let result = try await day.part2()
            #expect(result == 6)
         }
      }
   }
}

private let testInput =
"""
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
"""
