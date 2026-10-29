package study.translation;
import java.util.ArrayList;
/** New teaching module. ZERO=0, INC=1, DEC=-1; other tokens are signed int32 literals. */
public final class InstructionParser {
    // 工具类不需要创建对象；外部通过InstructionParser.parse直接调用。
    private InstructionParser() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
    // 按ASCII空格拆分输入，转换三个约定词和int整数；空串返回空数组，null或非法片段抛出参数异常。
    public static int[] parse(String input) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
    // 仅供parse调用：检查可选正负号和ASCII数字，再转换为int；越界时统一抛出参数异常。
    private static int parseNumber(String token) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
}
