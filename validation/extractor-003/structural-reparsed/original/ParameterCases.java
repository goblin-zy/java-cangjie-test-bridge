package fixtures;
import org.junit.jupiter.api.*;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

class ParameterCases {
    @BeforeAll static void start() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
    @AfterAll static void stop() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @ParameterizedTest
    @ValueSource(ints = {1, 2, 3})
    void input(int value) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
}

interface Contract {
    int fetch();
    default int defaultValue() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
}
