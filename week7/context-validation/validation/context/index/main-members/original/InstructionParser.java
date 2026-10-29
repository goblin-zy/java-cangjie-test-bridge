package study.translation;
import java.util.ArrayList;
/** New teaching module. ZERO=0, INC=1, DEC=-1; other tokens are signed int32 literals. */
public final class InstructionParser {
    // 工具类不需要创建对象；外部通过InstructionParser.parse直接调用。
    private InstructionParser() { }
    // 按ASCII空格拆分输入，转换三个约定词和int整数；空串返回空数组，null或非法片段抛出参数异常。
    public static int[] parse(String input) {
        if (input == null) throw new IllegalArgumentException("null input");
        var values = new ArrayList<Integer>();
        // 只把普通空格作为分隔符；保留的空片段在循环内跳过。
        for (String token : input.split(" ", -1)) {
            if (token.isEmpty()) continue;
            switch (token) {
                case "ZERO" -> values.add(0);
                case "INC" -> values.add(1);
                case "DEC" -> values.add(-1);
                default -> values.add(parseNumber(token));
            }
        }
        // 将Integer列表拆箱成int数组；断言检查数组内容，不检查对象身份。
        return values.stream().mapToInt(Integer::intValue).toArray();
    }
    // 仅供parse调用：检查可选正负号和ASCII数字，再转换为int；越界时统一抛出参数异常。
    private static int parseNumber(String token) {
        int start = (token.charAt(0) == '+' || token.charAt(0) == '-') ? 1 : 0;
        if (start == token.length()) throw new IllegalArgumentException("invalid token");
        for (int i = start; i < token.length(); i++) {
            char c = token.charAt(i);
            if (c < '0' || c > '9') throw new IllegalArgumentException("invalid token");
        }
        try { return Integer.parseInt(token); }
        catch (NumberFormatException e) { throw new IllegalArgumentException("out of int32 range"); }
    }
}
