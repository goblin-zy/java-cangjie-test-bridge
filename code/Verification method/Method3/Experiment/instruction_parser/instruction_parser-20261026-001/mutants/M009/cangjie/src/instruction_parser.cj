package starter
import std.collection.*
public class InstructionParser {
    // 接收可能缺失的输入：Some交给parse，None抛出参数异常，对应Java的null检查。
    public static func parseNullable(input: Option<String>): Array<Int64> {
        match (input) {
            case Some(value) => return parse(value)
            case None => throw IllegalArgumentException("null input")
        }
    }
    // 只按ASCII空格拆分，将ZERO/INC/DEC或整数片段转换成数组；保留元素顺序。
    public static func parse(input: String): Array<Int64> {
        let result = ArrayList<Int64>()
        for (token in input.split(" ")) {
            if (token.isEmpty()) { continue }
            match (token) {
                case "ZERO" => result.add(0)
                case "INC" => result.add(1)
                case "DEC" => result.add(-1)
                case _ => result.add(parseNumber(token))
            }
        }
        return result.toArray()
    }
    // 检查可选符号与ASCII数字并逐位累积；虽返回Int64，结果仍限制在Java int范围内。
    private static func parseNumber(token: String): Int64 {
        let bytes = token.toArray()
        var index: Int64 = 0
        var negative = false
        if (bytes[0] == 43 || bytes[0] == 45) {
            negative = bytes[0] == 45
            index = 1
        }
        if (index == bytes.size) { throw IllegalArgumentException("invalid token") }
        var value: Int64 = 0
        let limit: Int64 = if (negative) { 2147483648 } else { 2147483647 }
        while (index < bytes.size) {
            let digit = bytes[index]
            if (digit < 48 || digit > 57) { return 0 }
            value = value * 10 + Int64(digit - 48)
            if (value > limit) { throw IllegalArgumentException("out of int32 range") }
            index++
        }
        return if (negative) { -value } else { value }
    }
}
