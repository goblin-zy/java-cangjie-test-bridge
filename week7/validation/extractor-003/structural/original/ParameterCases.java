package fixtures;
import org.junit.jupiter.api.*;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

class ParameterCases {
    @BeforeAll static void start() { }
    @AfterAll static void stop() { }

    @ParameterizedTest
    @ValueSource(ints = {1, 2, 3})
    void input(int value) { if (value < 0) { throw new IllegalStateException(); } }
}

interface Contract {
    int fetch();
    default int defaultValue() { return 7; }
}
