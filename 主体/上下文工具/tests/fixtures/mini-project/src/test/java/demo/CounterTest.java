package demo;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class CounterTest extends BaseTest {
    private void addTwice() {
        counter.add(1);
        assertEquals(4, counter.value());
        counter.add(2);
    }

    @Test void sequence() {
        addTwice();
        assertEquals(6, counter.value(), "结果😀");
    }

    @Test void resource() {
        assertNotNull(getClass().getResourceAsStream("/data/values.txt"));
    }
}
