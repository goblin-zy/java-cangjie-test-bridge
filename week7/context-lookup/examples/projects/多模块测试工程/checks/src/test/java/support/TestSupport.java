package support;
import app.Cart;
import java.io.InputStream;
import static org.junit.jupiter.api.Assertions.*;
public class TestSupport {
    public static void check(Cart value) {
        value.add(1);
        assertEquals(3, value.total()); // 辅助方法中的断言必须保留
    }
    public static InputStream data() {
        return TestSupport.class.getResourceAsStream("/fixtures/price.txt");
    }
    public static void cycleA() { cycleB(); }
    public static void cycleB() { cycleA(); }
}
