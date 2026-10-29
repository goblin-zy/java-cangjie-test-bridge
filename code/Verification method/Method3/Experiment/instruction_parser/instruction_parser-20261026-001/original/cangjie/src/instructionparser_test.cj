package starter
import std.unittest.*
import std.unittest.testmacro.*

@Test
class InstructionParserTest {
    // 先检查长度，再逐元素比较；长度不同时停止，避免比较时越界。
    private func expectArray(actual: Array<Int64>, expected: Array<Int64>): Unit {
        @Assert(actual.size, expected.size)
        for (i in 0..expected.size) { @Expect(actual[i], expected[i]) }
    }
    // P01：空字符串应得到空数组。（新编样例）
    @TestCase
    func testEmpty(): Unit {
        let actual = InstructionParser.parse("")
        expectArray(actual, [])
    }
    // P02：仅包含空格时也应得到空数组。（新编样例）
    @TestCase
    func testSpaces(): Unit {
        let actual = InstructionParser.parse("   ")
        expectArray(actual, [])
    }
    // P03：检查三个约定指令词的映射和顺序。（新编样例）
    @TestCase
    func testNamedInstructions(): Unit {
        let actual = InstructionParser.parse("ZERO INC DEC")
        expectArray(actual, [0, 1, -1])
    }
    // P04：检查正负号、零和前导零的整数转换。（新编样例）
    @TestCase
    func testSignedNumbers(): Unit {
        let actual = InstructionParser.parse("-7 +8 0 007")
        expectArray(actual, [-7, 8, 0, 7])
    }
    // P05：检查连续空格及指令与数字混合输入。（新编样例）
    @TestCase
    func testRepeatedSpaces(): Unit {
        let actual = InstructionParser.parse("  INC  35 DEC ")
        expectArray(actual, [1, 35, -1])
    }
    // P06：检查Java int上下边界均可正常解析。（新编样例）
    @TestCase
    func testInt32Boundaries(): Unit {
        let actual = InstructionParser.parse("-2147483648 2147483647")
        expectArray(actual, [-2147483648, 2147483647])
    }
    // P07：未知词、单独符号、小数和制表符均应被拒绝。（新编样例）
    @TestCase
    func testInvalidTokens(): Unit {
        for (input in ["BOGUS", "+", "1.5", "INC\tDEC"]) {
            var caught = false
            try { InstructionParser.parse(input) } catch (_: IllegalArgumentException) { caught = true }
            @Expect(caught, true)
        }
    }
    // P08：检查超过int范围的正负数字均抛出参数异常。（新编样例）
    @TestCase
    func testOutOfRange(): Unit {
        for (input in ["2147483648", "-2147483649"]) {
            var caught = false
            try { InstructionParser.parse(input) } catch (_: IllegalArgumentException) { caught = true }
            @Expect(caught, true)
        }
    }
    // P09：检查缺失输入与空字符串的行为不同。（新编样例）
    @TestCase
    func testNullInput(): Unit {
        var caught = false
        try { InstructionParser.parseNullable(None) } catch (_: IllegalArgumentException) { caught = true }
        @Expect(caught, true)
    }
}
