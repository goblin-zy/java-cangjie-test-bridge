package sample;
import java.util.ArrayList;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class ListTest {
    private final List<String> values = new ArrayList<>();
    @BeforeEach void prepare() { values.clear(); }
    @AfterEach void cleanup() { values.clear(); }
    @Test void addThenClear() {
        values.add("one");
        expectSize(1);
        values.clear();
        assertTrue(values.isEmpty());
    }
    @Test void resourceExists() {
        assertNotNull(getClass().getResourceAsStream("/message.txt"));
    }
    void expectSize(int expected) { assertEquals(expected, values.size()); }
    void expectSize(int expected, String message) { assertEquals(expected, values.size(), message); }
}
