package support;
import app.Cart;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.AfterEach;
public class BaseCase {
    protected Cart cart = new Cart();
    @BeforeEach public void prepare() { cart.add(2); }
    @AfterEach public void clean() { cart.clear(); }
}
