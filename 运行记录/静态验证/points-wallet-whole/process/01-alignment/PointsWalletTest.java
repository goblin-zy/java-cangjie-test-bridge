package wallet;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class PointsWalletTest {
    private PointsWallet wallet;

    private PointsWallet newWallet() {
        return new PointsWallet(100);
    }

    @BeforeEach
    void setup() {
        wallet = newWallet();
    }

    @Test
    void spendsPointsInOrder() {
        assertTrue(wallet.spend(30));
        assertEquals(70, wallet.balance());
        assertTrue(wallet.spend(20));
        assertEquals(50, wallet.balance());
    }

    @Test
    void rejectsOverspending() {
        assertFalse(wallet.spend(150));
        assertEquals(100, wallet.balance());
    }
}
