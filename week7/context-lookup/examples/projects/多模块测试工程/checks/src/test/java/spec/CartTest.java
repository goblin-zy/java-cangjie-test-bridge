package spec;
import app.Limits;
import app.Engine;
import support.BaseCase;
import support.TestSupport;
import support.Over;
import org.junit.jupiter.api.Test;
import java.io.InputStream;
import static org.junit.jupiter.api.Assertions.*;
public class CartTest extends BaseCase {
    private static final String DATA = "/fixtures/price.txt";
    void seed() { TestSupport.check(cart); }
    @Test public void total() throws Exception {
        seed();
        try (InputStream input = TestSupport.data()) { assertNotNull(input); }
        assertEquals(Limits.THREE, cart.total());
    }
    @Test public void constantResource() {
        assertNotNull(getClass().getResourceAsStream(DATA));
    }
    @Test public void uncertain() {
        getClass().getResourceAsStream(System.getProperty("fixture.path"));
        Engine engine = null;
        engine.run();
        Over.check(1);
    }
    @Test public void cyclic() { TestSupport.cycleA(); }
}
