package fixtures;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.AfterEach;
import static org.junit.jupiter.api.Assertions.*;

/** 非账户类，用于核对提取器没有绑定业务名称。 */
class StructureCases<T extends Number> {
    private final String text = "花括号 { } 及中文与表情 😃";
    private int value;

    StructureCases() {
        this(3);
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
    StructureCases(int initial) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @BeforeEach
    void setup() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @AfterEach
    void cleanup() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test
    void lambdaWithBraces() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    int overloaded(int input) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
    T overloaded(T input) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    void localClassAndAnonymous() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    static { System.getProperty("fixture.only"); }

    static class NestedCase {
        @Test void nestedTest() {
            throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
        }
    }
}
