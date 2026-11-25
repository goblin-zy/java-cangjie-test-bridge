package demo;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

// 只用于静态分析，不运行这些测试；保留控制包围和延迟执行边界。
class FlowTest {
    void helper() { assertEquals(3, 3); }
    @Test void check() throws Exception {
        int value = 3;
        if (value > 0) { assertTrue(value > 0); }
        else { assertEquals(0, value); }
        for (int i = 0; i < 2; i++) { assertNotNull(new Object()); }
        try (java.io.ByteArrayInputStream input = new java.io.ByteArrayInputStream(new byte[0])) {
            assertEquals(-1, input.read());
        } catch (RuntimeException error) {
            fail(error.getMessage());
        } finally { helper(); }
        Runnable deferred = () -> { assertTrue(true); assert value == 3; };
        assertThrows(IllegalArgumentException.class, () -> { throw new IllegalArgumentException(); });
        switch (value) { case 3: assertEquals(3, value); break; default: fail("unexpected"); }
    }
    @Test void compactLambda() { assertAll(() -> assertTrue(true), () -> assertEquals(1, 1)); }
    @Test void longBody() {
        int a = 1; a++; a++; a++; a++; a++; a++; a++; a++; a++;
        a++; a++; a++; a++; a++; a++; a++; a++; a++; a++;
        a++; a++; a++; a++; a++; assertTrue(a > 20);
    }
}

class ShadowAssertTest {
    void assertEquals(int expected, int actual) { }
    void assertSomethingCustom() { }
    @Test void custom() { assertEquals(1, 2); assertSomethingCustom(); }
}
