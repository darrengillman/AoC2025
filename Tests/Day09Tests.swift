import Testing
import AoCTools

@testable import AdventOfCode

@Suite("Day09 Tests")
struct Day09Tests {
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
         let day = Day09(data: testInput)
         
         @Test("Part1 example")
         func testPart1() async throws {
            let result = try await day.part1()
            #expect(result == 50)
         }
         
         @Test("Part2 example")
         func testPart2() async throws {
            let result = try await day.part2()
            #expect(result == 24)
         }
         
         @Test("Import")
         func testParsing() async throws {
            let points = day.parse(testInput)
            #expect(points.count == 8)
         }

      }
   }
}

private let testInput =
  """
  7,1
  11,1
  11,7
  9,7
  9,5
  2,5
  2,3
  7,3
  """
