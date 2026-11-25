package demo;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.AfterEach;

class BaseTest {
    protected Counter counter;
    @BeforeEach void prepare() { counter = new Counter(3); }
    @AfterEach void clean() { counter = null; }
}
