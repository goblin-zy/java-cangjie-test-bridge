package fixtures;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.AfterEach;
import static org.junit.jupiter.api.Assertions.*;

/** 非账户类，用于核对提取器没有绑定业务名称。 */
class StructureCases<T extends Number> {
    private final String text = "花括号 { } 及中文与表情 😃";
    private int value;

    StructureCases() { this(3); }
    StructureCases(int initial) { value = initial; }

    @BeforeEach
    void setup() { value = 3; }

    @AfterEach
    void cleanup() { value = 0; }

    @Test
    void lambdaWithBraces() {
        assertThrows(IllegalArgumentException.class, () -> {
            if (value < 10) { throw new IllegalArgumentException("not a body boundary: }"); }
        });
    }

    int overloaded(int input) { return input + value; }
    T overloaded(T input) { return input; }

    void localClassAndAnonymous() {
        class Local { int value() { return 1; } }
        Runnable action = new Runnable() { public void run() { System.out.println(text); } };
        action.run();
    }

    static { System.getProperty("fixture.only"); }

    static class NestedCase {
        @Test void nestedTest() { assertTrue(true); }
    }
}
