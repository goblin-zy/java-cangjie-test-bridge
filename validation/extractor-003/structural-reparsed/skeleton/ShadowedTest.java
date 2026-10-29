package fixtures;
import org.junit.jupiter.api.*;

@interface Test { }
class ShadowedTest {
    // 同名本地注解不能被误认为JUnit测试。
    @Test void customAnnotation() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
}
