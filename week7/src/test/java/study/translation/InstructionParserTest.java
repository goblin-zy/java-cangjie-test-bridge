package study.translation;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class InstructionParserTest {
    // P01：空字符串应得到空数组。（新编样例）
    @Test void testEmpty() {
        assertArrayEquals(new int[]{}, InstructionParser.parse(""));
    }
    // P02：仅包含空格时也应得到空数组。（新编样例）
    @Test void testSpaces() {
        assertArrayEquals(new int[]{}, InstructionParser.parse("   "));
    }
    // P03：检查三个约定指令词的映射和顺序。（新编样例）
    @Test void testNamedInstructions() {
        assertArrayEquals(new int[]{0, 1, -1}, InstructionParser.parse("ZERO INC DEC"));
    }
    // P04：检查正负号、零和前导零的整数转换。（新编样例）
    @Test void testSignedNumbers() {
        assertArrayEquals(new int[]{-7, 8, 0, 7}, InstructionParser.parse("-7 +8 0 007"));
    }
    // P05：检查连续空格及指令与数字混合输入。（新编样例）
    @Test void testRepeatedSpaces() {
        assertArrayEquals(new int[]{1, 35, -1}, InstructionParser.parse("  INC  35 DEC "));
    }
    // P06：检查Java int上下边界均可正常解析。（新编样例）
    @Test void testInt32Boundaries() {
        assertArrayEquals(new int[]{-2147483648, 2147483647}, InstructionParser.parse("-2147483648 2147483647"));
    }
    // P07：未知词、单独符号、小数和制表符均应被拒绝。（新编样例）
    @Test void testInvalidTokens() {
        for (String input : new String[]{"BOGUS", "+", "1.5", "INC\tDEC"}) {
            assertThrows(IllegalArgumentException.class, () -> InstructionParser.parse(input));
        }
    }
    // P08：检查超过int范围的正负数字均抛出参数异常。（新编样例）
    @Test void testOutOfRange() {
        for (String input : new String[]{"2147483648", "-2147483649"}) {
            assertThrows(IllegalArgumentException.class, () -> InstructionParser.parse(input));
        }
    }
    // P09：检查缺失输入与空字符串的行为不同。（新编样例）
    @Test void testNullInput() {
        assertThrows(IllegalArgumentException.class, () -> InstructionParser.parse(null));
    }
}
